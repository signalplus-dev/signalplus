module Responders
  module Twitter
    class Reply
      attr_reader :brand, :message, :hashtag, :reply_type, :client, :id

      class << self
        # @param brand   [Brand]
        # @param message [Twitter::Tweet|Twitter::DirectMessage]
        # @param hashtag [String]
        # @param as_json [Hash] A way to build a Reply object without the Tweet/Direct Message objects
        # @return        [Responders::Twitter::TweetReply|Responders::Twitter::DirectMessageReply]
        def build(brand: nil, message: nil, hashtag: nil, as_json: nil)
          if as_json.is_a?(Hash)
            build_from_hash(brand, as_json.with_indifferent_access)
          else
            build_from_twitter_message(brand, message, hashtag)
          end
        end

        private

        # @param brand   [Brand]
        # @param message [Twitter::Tweet|Twitter::DirectMessage]
        # @param hashtag [String]
        # @return        [Responders::Twitter::TweetReply|Responders::Twitter::DirectMessageReply]
        def build_from_twitter_message(brand, message, hashtag)
          case message
          when ::Twitter::Tweet
            Responders::Twitter::TweetReply.new(brand: brand, message: message, hashtag: hashtag)
          when ::Twitter::DirectMessage
            Responders::Twitter::DirectMessageReply.new(brand: brand, message: message, hashtag: hashtag)
          else
            raise ArgumentError.new("#{message.class} is a message type that is not supported")
          end
        end

        # @param brand   [Brand]
        # @param as_json [Hash] A way to build a Reply object without the Tweet/Direct Message objects
        # @return        [Responders::Twitter::TweetReply|Responders::Twitter::DirectMessageReply]
        def build_from_hash(brand, as_json)
          case as_json[:reply_type]
          when 'Tweet'
            Responders::Twitter::TweetReply.new(brand: brand, as_json: as_json)
          when 'DirectMessage'
            Responders::Twitter::DirectMessageReply.new(brand: brand, as_json: as_json)
          else
            raise ArgumentError.new("#{message.class} is a message type that is not supported")
          end
        end
      end

      def initialize(brand: nil, message: nil, hashtag: nil, as_json: nil)
        @brand   = brand
        if as_json
          @as_json = as_json.with_indifferent_access
          @hashtag = @as_json[:hashtag]
          @id      = @as_json[:reply_id]
          @to      = @as_json[:to]
        else
          @message = message
          @hashtag = hashtag.downcase
          @id      = message.id
        end
      end

      def reply!(client = nil)
        @client = client || brand.twitter_rest_client
        tweet = reply_to_message!
        TwitterReply.create!(as_json.merge(tweet_id: tweet.id))
      rescue StandardError => e
        # do some logging
        Rollbar.error(e)
      end

      # @return [Boolean]
      def tweet?
        false
      end

      # @return [Boolean]
      def direct_message?
        false
      end

      # @return [Hash]
      def as_json
        @as_json ||= {
          date:          date,
          from:          from,
          to:            to,
          hashtag:       hashtag,
          reply_id:   reply_id,
          reply_type: reply_type,
        }
      end

      # @return [String]
      def to
        @to || sender.try(:screen_name)
      end

      private

      # @return [String]
      def date
        Date.current.to_s
      end

      # @return [String]
      def from
        brand.name
      end

      # @return [Fixnum]
      def reply_id
        message.id
      end

      # @return [String]
      def reply_type
        class_name_bits = self.class.to_s.demodulize.underscore.split('_')
        if class_name_bits.size == 1
          class_name_bits.first.camelize
        else
          class_name_bits[0...-1].join('_').camelize
        end
      end

      # @return [Twitter::User]
      def sender
        raise StandardError.new('Must override this method and must return a Twitter::User object')
      end

      # @return [Hash]
      def signal_reply
        # Should eventually be the signal of the brand
        @signal_reply ||= Listener::HASHTAGS_TO_LISTEN_TO[hashtag]
      end

      def reply_to_message!
        if signal_reply['image'].is_a?(String)
          begin
            temp_image = TempImage.new(signal_reply['image'])
            file = File.open(temp_image.file.path)
            reply_with_text_and_image!(file, temp_image)
          rescue Aws::S3::Errors::NoSuchKey
            reply_with_text!
          end
        else
          reply_with_text!
        end
      end

      # @return [String]
      def text_reply
        # a "d" at the beginning of the message indicates the desire to direct message the user
        @text_reply ||= "d @#{to} #{base_text_reply}"
      end

      # @return [String]
      def base_text_reply
        signal_reply['text_reply']
      end

      def reply_with_text!
        client.update(text_reply)
      end

      def reply_with_text_and_image!(file, temp_image)
        client.update_with_media(text_reply, file)
      ensure
        file.close
        temp_image.file.close
        temp_image.file.unlink
      end
    end
  end
end

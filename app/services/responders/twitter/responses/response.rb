module Responders
  module Twitter
    class Response
      attr_reader :brand, :message, :hashtag, :response_type, :client, :id

      class << self
        # @param brand   [Brand]
        # @param message [Twitter::Tweet|Twitter::DirectMessage]
        # @param hashtag [String]
        # @param as_json [Hash] A way to build a Response object without the Tweet/Direct Message objects
        # @return        [Responders::Twitter::TweetResponse|Responders::Twitter::DirectMessageResponse]
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
        # @return        [Responders::Twitter::TweetResponse|Responders::Twitter::DirectMessageResponse]
        def build_from_twitter_message(brand, message, hashtag)
          case message
          when ::Twitter::Tweet
            Responders::Twitter::TweetResponse.new(brand: brand, message: message, hashtag: hashtag)
          when ::Twitter::DirectMessage
            Responders::Twitter::DirectMessageResponse.new(brand: brand, message: message, hashtag: hashtag)
          else
            raise ArgumentError.new("#{message.class} is a message type that is not supported")
          end
        end

        # @param brand   [Brand]
        # @param as_json [Hash] A way to build a Response object without the Tweet/Direct Message objects
        # @return        [Responders::Twitter::TweetResponse|Responders::Twitter::DirectMessageResponse]
        def build_from_hash(brand, as_json)
          case as_json[:response_type]
          when 'Tweet'
            Responders::Twitter::TweetResponse.new(brand: brand, as_json: as_json)
          when 'DirectMessage'
            Responders::Twitter::DirectMessageResponse.new(brand: brand, as_json: as_json)
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
          @id      = @as_json[:response_id]
          @to      = @as_json[:to]
        else
          @message = message
          @hashtag = hashtag.downcase
          @id      = message.id
        end
      end

      def respond!(client = nil)
        @client = client || brand.twitter_rest_client
        tweet = respond_to_message!
        TwitterResponse.create!(as_json.merge(tweet_id: tweet.id))
      rescue StandardError => e
        # do some logging
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
          response_id:   response_id,
          response_type: response_type,
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
      def response_id
        message.id
      end

      # @return [String]
      def response_type
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
      def signal_response
        # Should eventually be the signal of the brand
        @signal_response ||= Listener::HASHTAGS_TO_LISTEN_TO[hashtag]
      end

      def respond_to_message!
        if signal_response['image'].is_a?(String)
          begin
            temp_image = TempImage.new(signal_response['image'])
            file = File.open(temp_image.file.path)
            respond_with_text_and_image!(file, temp_image)
          rescue Aws::S3::Errors::NoSuchKey
            respond_with_text!
          end
        else
          respond_with_text!
        end
      end

      # @return [String]
      def text_response
        # a "d" at the beginning of the message indicates the desire to direct message the user
        @text_response ||= "d @#{to} #{base_text_response}"
      end

      # @return [String]
      def base_text_response
        signal_response['text_response']
      end

      def respond_with_text!
        client.update(text_response)
      end

      def respond_with_text_and_image!(file, temp_image)
        client.update_with_media(text_response, file)
      ensure
        file.close
        temp_image.file.close
        temp_image.file.unlink
      end
    end
  end
end

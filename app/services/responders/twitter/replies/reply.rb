module Responders
  module Twitter
    class Reply
      attr_reader :brand, :message, :client, :id, :listen_signal

      class << self
        # @param brand         [Brand]
        # @param message       [Twitter::Tweet|Twitter::DirectMessage]
        # @param listen_signal [ListenSignal]
        # @param as_json       [Hash] A way to build a Reply object without the Tweet/Direct Message objects
        # @return              [Responders::Twitter::TweetReply|Responders::Twitter::DirectMessageReply]
        def build(brand: nil, message: nil, listen_signal: nil, as_json: nil)
          if as_json.is_a?(Hash)
            build_from_hash(brand, as_json.with_indifferent_access)
          else
            build_from_twitter_message(brand, message, listen_signal)
          end
        end

        private

        # @param brand         [Brand]
        # @param message       [Twitter::Tweet|Twitter::DirectMessage]
        # @param listen_signal [ListenSignal]
        # @return              [Responders::Twitter::TweetReply|Responders::Twitter::DirectMessageReply]
        def build_from_twitter_message(brand, message, listen_signal)
          case message
          when ::Twitter::Tweet
            Responders::Twitter::TweetReply.new(brand: brand, message: message, listen_signal: listen_signal)
          when ::Twitter::DirectMessage
            Responders::Twitter::DirectMessageReply.new(brand: brand, message: message, listen_signal: listen_signal)
          else
            raise ArgumentError.new("#{message.class} is a message type that is not supported")
          end
        end

        # @param brand   [Brand]
        # @param as_json [Hash] A way to build a Reply object without the Tweet/Direct Message objects
        # @return        [Responders::Twitter::TweetReply|Responders::Twitter::DirectMessageReply]
        def build_from_hash(brand, as_json)
          case as_json[:request_tweet_type]
          when 'Tweet'
            Responders::Twitter::TweetReply.new(brand: brand, as_json: as_json)
          when 'DirectMessage'
            Responders::Twitter::DirectMessageReply.new(brand: brand, as_json: as_json)
          else
            raise ArgumentError.new("#{message.class} is a message type that is not supported")
          end
        end
      end

      def initialize(brand: nil, message: nil, listen_signal: nil, as_json: nil)
        @brand   = brand
        if as_json
          @as_json       = as_json.with_indifferent_access
          @id            = @as_json[:request_tweet_id]
          @to            = @as_json[:to]
          @listen_signal = ListenSignal.find(@as_json[:listen_signal_id])
          @response      = Response.find(@as_json[:response_id])
        else
          @message       = message
          @listen_signal = listen_signal
          @id            = message.id
        end
      end

      def respond!(client = nil)
        @client = client || brand.twitter_rest_client

        ApplicationRecord.transaction do
          twitter_response = TwitterResponse.create!(as_json)
          tweet_reply = reply_to_message!
          twitter_response.update!(reply_tweet_id: tweet_reply.id, reply_tweet_type: 'DirectMessage')
        end
      rescue StandardError => e
        # do some logging
        Rollbar.error(e, brand_id: brand.id)
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
          date:               Date.current.to_s,
          brand_id:           brand.id,
          listen_signal_id:   listen_signal.id,
          response_id:        response.id,
          to:                 to,
          request_tweet_id:   request_tweet_id,
          request_tweet_type: request_tweet_type,
        }
      end

      # @return [String]
      def to
        @to || request_user.try(:screen_name)
      end

      private

      # @return [Fixnum]
      def request_tweet_id
        message.id
      end

      # @return [String]
      def request_tweet_type
        class_name_bits = self.class.to_s.demodulize.underscore.split('_')
        if class_name_bits.size == 1
          class_name_bits.first.camelize
        else
          class_name_bits[0...-1].join('_').camelize
        end
      end

      # @return [Twitter::User]
      def request_user
        raise StandardError.new('Must override this method and must return a Twitter::User object')
      end

      # @return [Response]
      def response
        @response ||= listen_signal.response(to)
      end

      def reply_to_message!
        if response.has_image?
          begin
            reply_with_text_and_image!(*file_and_temp_image)
          rescue Aws::S3::Errors::NoSuchKey
            reply_with_text!
          end
        else
          reply_with_text!
        end
      end

      def reply_with_text!
        client.update(text_reply)
      end

      # @return [String]
      def text_reply
        # a "d" at the beginning of the message indicates the desire to direct message the user
        @text_reply ||= "d @#{to} #{base_text_reply}"
      end

      # @return [String]
      def base_text_reply
        response.message
      end

      def reply_with_text_and_image!(file, temp_image)
        client.update_with_media(text_reply, file)
      ensure
        file.close
        temp_image.file.close
        temp_image.file.unlink
      end

      # @return [Array]
      def file_and_temp_image
        temp_image = TempImage.new(response.image_name)
        file = File.open(temp_image.file.path)
        [file, temp_image]
      end
    end
  end
end

module Responders
  module Twitter
    class Response
      attr_reader :brand, :message, :hashtag, :response_type
      # @param brand   [Brand]
      # @param message [Twitter::Tweet|Twitter::DirectMessage]
      # @return        [Responders::Twitter::TweetResponse|Responders::Twitter::DirectMessageResponse]
      def self.build(brand, message, hashtag)
        case message
        when ::Twitter::Tweet
          Responders::Twitter::TweetResponse.new(brand, message, hashtag)
        when ::Twitter::DirectMessage
          Responders::Twitter::DirectMessageResponse.new(brand, message, hashtag)
        else
          raise ArgumentError.new("#{message.class} is a message type that is not supported")
        end
      end

      # @return [Hash]
      def as_json
        {
          date:          date,
          from:          from,
          to:            to,
          hashtag:       hashtag.downcase,
          response_id:   response_id,
          response_type: response_type,
        }
      end

      # @return [String]
      def to
        sender.screen_name
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
    end
  end
end

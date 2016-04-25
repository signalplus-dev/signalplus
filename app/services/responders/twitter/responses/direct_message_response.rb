require_relative 'response'

module Responders
  module Twitter
    class DirectMessageResponse < Response
      # @param brand   [Brand]
      # @param message [Twitter::DirectMessage]
      def initialize(brand, message, hashtag)
        @brand   = brand
        @message = message
        @hashtag = hashtag
      end

      # @return [Twitter::User]
      def sender
        message.sender
      end
    end
  end
end

require_relative 'response'

module Responders
  module Twitter
    class TweetResponse < Response
      # @param brand   [Brand]
      # @param message [Twitter::Tweet]
      def initialize(brand, message, hashtag)
        @brand   = brand
        @message = message
        @hashtag = hashtag
      end

      # @return [Twitter::User]
      def sender
        message.user
      end
    end
  end
end

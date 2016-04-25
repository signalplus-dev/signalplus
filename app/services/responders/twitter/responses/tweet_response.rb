require_relative 'response'

module Responders
  module Twitter
    class TweetResponse < Response
      # @return [Twitter::User]
      def sender
        message.user
      end

      # @return [Boolean]
      def tweet?
        true
      end
    end
  end
end

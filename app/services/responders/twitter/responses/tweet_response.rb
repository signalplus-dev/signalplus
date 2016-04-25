require_relative 'response'

module Responders
  module Twitter
    class TweetResponse < Response
      # @return [Twitter::User]
      def sender
        message.user
      end
    end
  end
end

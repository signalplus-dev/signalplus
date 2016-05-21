require_relative 'reply'

module Responders
  module Twitter
    class TweetReply < Reply
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

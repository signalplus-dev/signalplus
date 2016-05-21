require_relative 'response'

module Responders
  module Twitter
    class DirectMessageReply < Reply
      # @return [Twitter::User]
      def sender
        message.sender
      end

      # @return [Boolean]
      def direct_message?
        true
      end
    end
  end
end

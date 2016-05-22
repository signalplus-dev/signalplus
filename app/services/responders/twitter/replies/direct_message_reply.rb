require_relative 'reply'

module Responders
  module Twitter
    class DirectMessageReply < Reply
      # @return [Twitter::User]
      def request_user
        message.sender
      end

      # @return [Boolean]
      def direct_message?
        true
      end
    end
  end
end

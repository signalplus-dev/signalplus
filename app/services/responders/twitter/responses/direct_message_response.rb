require_relative 'response'

module Responders
  module Twitter
    class DirectMessageResponse < Response
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

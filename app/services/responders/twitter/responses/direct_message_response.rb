require_relative 'response'

module Responders
  module Twitter
    class DirectMessageResponse < Response
      # @return [Twitter::User]
      def sender
        message.sender
      end
    end
  end
end

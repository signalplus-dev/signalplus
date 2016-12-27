module ApiErrors
  class StandardError < StandardError
    attr_reader :status, :dev_message, :message

    def initialize(dev_message: nil, message: nil, status: nil)
      @dev_message = dev_message || message || 'An unexpected error happened'
      @message     = message || 'Sorry, we could not complete your request'
      @status      = status
    end

    def as_json
      {
        dev_message: dev_message,
        message:     message,
      }
    end
  end
end

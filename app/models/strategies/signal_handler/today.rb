module SignalHandler
  class Today < SignalHandler::Signal
    def initialize(name, exp_date, user)
      super(name, exp_date, user)
      @signal_type = ListenSignal::Types::TODAY
    end

    def create!
      super(@signal_type)
    end
  end
end

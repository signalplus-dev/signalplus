module SignalHandler
  class Contest < SignalHandler::Signal
    def initialize(name, exp_date, user)
      super(name, exp_date, user)
      @signal_type = ListenSignal::Types::CONTEST
    end

    def create
      super(@signal_type)
    end
  end
end

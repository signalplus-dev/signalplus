module SignalHandler
  class Today < Signal
    def initialize(name, status, exp_date, user)
      super(name, status, exp_date, user)
      @signal_type = ListenSignal::Types::TODAY
    end

    def create
      super(@signal_type)
    end
  end
end

module SignalHandler
  class Offer < Signal
    def initialize(name, status, exp_date, user)
      super(name, status, exp_date, user)
      @signal_type = ListenSignal::Types::OFFER
    end

    def create
      super(@signal_type)
    end
  end
end

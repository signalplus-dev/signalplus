module SignalHandler
  class Offer < SignalHandler::Signal
    def initialize(name, exp_date, user)
      super(name, exp_date, user)
      @signal_type = ListenSignal::Types::OFFERS
    end

    def create!
      super(@signal_type)
    end
  end
end

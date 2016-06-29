module SignalHandler
  class Reminder < Signal
    def initialize(name, status, exp_date, user)
      super(name, status, exp_date, user)
      @signal_type = ListenSignal::Types::REMINDER
    end

    def create
      super(@signal_type)
    end
  end
end

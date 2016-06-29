module SignalHandler
  class Signal
    def initialize(name, status, exp_date, user)
      @name = name
      @status = status
      @exp_date = exp_date
      @brand = user.brand
      @identity = @brand.identity
    end

    def create(signal_type)
      ListenSignal.create! do |s|
        s.brand = @brand
        s.identity = @identity
        s.name = @name
        s.status = @status
        s.exp_date = @exp_date
        s.type = signal_type
      end
    end
  end
end

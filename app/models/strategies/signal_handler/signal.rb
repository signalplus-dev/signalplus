module SignalHandler
  class Signal
    def initialize(name, status, exp_date, user)
      @name = name
      @status = status
      @exp_date = exp_date
      @brand = user.brand
      @identity = @brand.twitter_identity
    end

    def create!(signal_type)
      ListenSignal.create! do |s|
        s.brand = @brand
        s.identity = @identity
        s.name = @name
        s.active = @status
        s.expiration_date = @exp_date
        s.signal_type = signal_type
      end
    end
  end
end

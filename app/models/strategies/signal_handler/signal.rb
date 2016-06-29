module SignalHandler
  class Signal
    def initialize(name, exp_date, user)
      @name = name
      @exp_date = exp_date
      @active = false
      @brand = user.brand
      @identity = @brand.twitter_identity
    end

    def create!(signal_type)
      ListenSignal.create! do |s|
        s.brand = @brand
        s.identity = @identity
        s.name = @name
        s.active = @active
        s.expiration_date = @exp_date
        s.signal_type = signal_type
      end
    end
  end
end

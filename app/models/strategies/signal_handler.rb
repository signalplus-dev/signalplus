module SignalHandler
  def self.create_signal(signal_type, name, exp_date, user)
    signal_type_name = get_signal_name(signal_type)
    signal_class = "SignalHandler::#{signal_type_name}".constantize

    signal = signal_class.new(name, exp_date, user)
    signal.create!
  end

  def self.get_signal_name(signal_type)
    signal_type.present? ? signal_type.to_s.camelize : 'Signal'
  end
end

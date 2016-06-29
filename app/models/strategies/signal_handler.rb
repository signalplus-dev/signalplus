module SignalHandler
  def self.create_signal(signal_type, name, status, exp_date, user)
    signal_type_name = get_signal_name(signal_type)
    signal = const_get("SignalHandler::#{signal_type_name}")

    signal.create(name, status, exp_date, user)
  end

  def self.get_signal_name(signal_type)
    signal_type.present? signal_type.to_s.camelize : 'Signal'
  end
end

module ListenSignalsHelper
  def get_signal_icon(path)
    content_tag(:div, image_tag("icons/#{path}", width:'36', height:'44'), class: 'panel-icon')
  end

  def get_signal_type_icon(signal_type)
    path = signal_type.to_s + '.png'
    get_signal_icon(path)
  end

  def get_signal_type_text(signal_type)
    case signal_type
      when ListenSignal::Types::OFFER
        'Send a special offer every time a follower sends a custom hashtag'
      when ListenSignal::Types::TODAY
        'Send a summary of your location or event each day a follower uses a custom hashtag'
      when ListenSignal::Types::CONTEST
        'Run a contest for your followers for a specific date range'
      when ListenSignal::Types::REMINDER
        'Send a reminder on a specific date to users when they use a custom hashtag'
    end
  end
end

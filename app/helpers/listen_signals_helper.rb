module ListenSignalsHelper
  def get_signal_icon(path)
    content_tag(:div, image_tag("icons/#{path}", width:'36', height:'44'), class: 'panel-icon')
  end
end

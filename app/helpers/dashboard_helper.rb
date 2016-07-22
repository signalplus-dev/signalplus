module DashboardHelper
  def get_signal_icon(path)
    content_tag(:div, image_tag("icons/#{path}", width:'36', height:'44'), class: 'panel-icon')
  end

  def get_signal_type_icon(signal_type)
    path = signal_type.to_s + '.png'
    get_signal_icon(path)
  end
end

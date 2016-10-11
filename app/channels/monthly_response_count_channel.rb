class MonthlyResponseCountChannel < ApplicationCable::Channel
  def subscribed
    reject unless can_subscribe_to_channel?
    stream_from "monthly_response_count_#{params[:brand_id]}"
  end

  private

  def can_subscribe_to_channel?
    params[:brand_id].to_i == current_user.brand_id
  end
end

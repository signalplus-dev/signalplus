class Api::V1::ListenSignalsController < Api::V1::BaseController
  before_action :get_brand, only: [:index]
  before_action :ensure_user_can_get_signal_info, only: [:index]

  def index
    render json: @brand.listen_signals, each_serializer: ListenSignalSerializer
  end

  private

  def get_brand
    @brand = Brand
               .where(id: current_user.brand_id)
               .includes(:subscription)
               .first

    unless @brand
      raise ApiErrors::StandardError.new(
        message: 'Sorry, we could not process your request',
        status: 400,
      )
    end
  end

  def ensure_user_can_get_signal_info
    if current_user.brand_id != @brand.id
      raise ApiErrors::StandardError.new(
        message: 'Sorry, you are not authorized to perfom this action',
        status: 401,
      )
    end
  end
end

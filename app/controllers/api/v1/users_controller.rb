class Api::V1::UsersController < Api::V1::BaseController
  before_action :get_brand, only: [:show, :update]
  before_action :ensure_user_can_perform_action, only: [:show]

  def show
    render json: current_user, serializer: UserSerializer
  end

  def update
    ActiveRecord::Base.transaction do
      current_user.update!(user_update_params) if user_update_params
      @brand.update!(brand_update_params) if brand_update_params
    end

    render json: current_user, serializer: UserSerializer
  rescue ActionController::ParameterMissing => e
    raise ApiErrors::StandardError.new(
      message: e.message,
      status: 400,
    )
  end

  private

  def user_update_params
    params.require(:user).permit(:email, :email_subscription)
  end

  def brand_update_params
    params.dig(:brand).try(:permit, :tz, :accepted_terms_of_use)
  end
end

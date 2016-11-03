class Api::V1::BrandsController < Api::V1::BaseController
  before_action :get_brand, only: [:show, :update_account_info]
  before_action :ensure_user_can_perform_action, only: [:show]

  def show
    render json: @brand, serializer: BrandSerializer
  end

  def update_account_info
    user = @brand.twitter_admin
    user.update!(account_info_params)

    render json: @brand, serializer: BrandSerializer
  end

  private

  def account_info_params
    params.permit(:email, :email_subscription, :tz)
  end
end

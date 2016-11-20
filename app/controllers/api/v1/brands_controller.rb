class Api::V1::BrandsController < Api::V1::BaseController
  before_action :get_brand, only: [:show, :update_account_info]
  before_action :ensure_user_can_perform_action, only: [:show]

  def show
    render json: @brand, serializer: BrandSerializer
  end

  # def update_account_info
  #   user = @brand.twitter_admin
  #   @brand.update!(brand_update_params)
  #   user.update!(user_update_params)

  #   render json: @brand, serializer: BrandSerializer
  # end

  # private

  # def user_update_params
  #   params.permit(:email, :email_subscription)
  # end

  # def brand_update_params
  #   params.permit(:tz)
  # end
end

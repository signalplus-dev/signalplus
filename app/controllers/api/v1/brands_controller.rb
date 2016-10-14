class Api::V1::BrandsController < Api::V1::BaseController
  before_action :get_brand, only: [:show, :update_account_email]
  before_action :ensure_user_can_perform_action, only: [:show]

  def show
    render json: @brand, serializer: BrandSerializer
  end

  def update_account_email
    binding.pry
    @brand.twitter_admin_email.update!()
  end

  private

  def brand_accont(params)
    params.permit(:twitter_admin_email, :account_tz)
  end
end

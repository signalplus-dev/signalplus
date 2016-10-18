class Api::V1::BrandsController < Api::V1::BaseController
  before_action :get_brand, only: [:show, :update_account_email]
  before_action :ensure_user_can_perform_action, only: [:show]

  def show
    render json: @brand, serializer: BrandSerializer
  end

  def update_account_info
    binding.pry

    params = account_info_params(params)
    update_timezone(params[:tz])
    update_twitter_admin_info(params[:twitter_admin_email], params[:email_subscription])

    render json: @brand, serializer: BrandSerializer
  end

  private

  def account_info_params(params)
    params.permit(:twitter_admin_email, :email_subscription, :tz)
  end

  def update_twitter_admin_info(email, email_subscription)
    @brand.twitter_admin.update!(email: email, email_subscription: email_subscription)
  end

  def update_timezone(tz)
    @brand.update!(tz: tz)
  end
end

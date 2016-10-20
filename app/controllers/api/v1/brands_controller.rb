class Api::V1::BrandsController < Api::V1::BaseController
  before_action :get_brand, only: [:show, :update_account_info]
  before_action :ensure_user_can_perform_action, only: [:show]

  def show
    render json: @brand, serializer: BrandSerializer
  end

  def update_account_info
    twitter_admin_params = {
      email: params[:twitter_admin_email],
      email_subscription: params[:email_subscription]
    }

    ActiveRecord::Base.transaction do
      @brand.twitter_admin.update!(twitter_admin_params)
      @brand.update!(tz: params[:tz])
    end

    render json: @brand, serializer: BrandSerializer
  end
end

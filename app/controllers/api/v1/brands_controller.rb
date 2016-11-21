class Api::V1::BrandsController < Api::V1::BaseController
  before_action :get_brand, only: [:show, :update_account_info]
  before_action :ensure_user_can_perform_action, only: [:show]

  def show
    render json: @brand, serializer: BrandSerializer
  end
end

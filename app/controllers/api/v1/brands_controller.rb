class Api::V1::BrandsController < Api::V1::BaseController
  before_action :get_brand, only: [:show, :update_account_info, :destroy]
  before_action :ensure_user_can_perform_action, only: [:show, :destroy]

  def show
    render json: @brand, serializer: BrandSerializer
  end

  def destroy
    @brand.delete_account
    sign_out current_user
    redirect_to root_path
  end
end

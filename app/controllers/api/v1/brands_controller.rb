class Api::V1::BrandsController < Api::V1::BaseController
  before_action :get_brand, only: [:show]
  before_action :ensure_user_can_get_brand_info, only: [:show]

  def show
    render json: @brand, serializer: BrandSerializer
  end

  private

  def get_brand
    @brand = Brand
               .where(id: current_user.brand_id)
               .includes(:subscription)
               .first

    unless @brand
      raise ApiErrors::StandardError.new(
        message: 'Sorry, that resource does not exist',
        status: 404,
      )
    end
  end

  def ensure_user_can_get_brand_info
    if current_user.brand_id != @brand.id
      raise ApiErrors::StandardError.new(
        message: 'Sorry, you are not authorized to perfom this action',
        status: 401,
      )
    end
  end
end

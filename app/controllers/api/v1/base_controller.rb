class Api::V1::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_user!
  force_ssl if Rails.env.production?
  protect_from_forgery with: :null_session
  rescue_from ApiErrors::StandardError, with: :show_error

  def test
    render json: 'ok'
  end

  private

  def show_error(e)
    render json: e.as_json, status: e.status
  end

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

  def ensure_user_can_perform_action
    if current_user.brand_id != @brand.id
      raise ApiErrors::StandardError.new(
        message: 'Sorry, you are not authorized to perfom this action',
        status: 401,
      )
    end
  end
end

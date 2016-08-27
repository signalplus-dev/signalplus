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
end

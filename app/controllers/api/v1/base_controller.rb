class Api::V1::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  force_ssl
  protect_from_forgery with: :null_session
  rescue_from ApiErrors::ApiStandardError, with: :show_error

  private

  def current_user
  end

  def show_error(e)
    render json: e.as_json, status: e.status
  end
end

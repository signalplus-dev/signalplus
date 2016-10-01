class Api::V1::BaseController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_user!
  force_ssl if Rails.env.production?
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::ActiveRecordError, with: :handle_active_record_error
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

  def handle_active_record_error
    raise ApiErrors::StandardError.new(
      message: 'Sorry, we could not create your signal',
      status: 400,
    )
  end

  # Should be used for creation and update endpoints.
  # Use selectively and explicitly.
  def ensure_has_subscription
    if !has_valid_subscription?
      raise ApiErrors::StandardError.new(
        message: 'Sorry, you must have a valid subscription to perform this action',
        status: 403,
      )
    end
  end

  def has_valid_subscription?
    subscription = @brand.subscription
    !!subscription && subscription.valid_and_paid_for?
  end
end

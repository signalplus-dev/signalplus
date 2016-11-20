class Api::V1::BaseController < ApplicationController
  alias_method :non_api_authenticate_user!, :authenticate_user!
  alias_method :non_api_current_user, :current_user

  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_csrf_token!, only: [:token]
  before_action :authenticate_user!, except: [:token]
  around_action :set_time_zone, except: [:token, :test]
  protect_from_forgery with: :null_session, except: [:token]

  rescue_from ActiveRecord::ActiveRecordError, with: :handle_active_record_error
  rescue_from ApiErrors::StandardError, with: :show_error

  def test
    render json: 'ok'
  end

  def token
    render_new_token(non_api_current_user)
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

  def authenticate_csrf_token!
    non_api_authenticate_user!
  end

  def render_new_token(user)
    # extract client_id from auth header
    client_id = request.headers['client']

    # update token, generate updated auth headers for response
    new_auth_header = user.create_new_auth_token(client_id)

    # update response with the header that will be required by the next request
    response.headers.merge!(new_auth_header)

    render json: { success: true }
  end

  def set_time_zone(&block)
    # Check if there is a time zone in the params
    time_zone = params[:brand].try(:[], :tz).to_s
    # Check if the brand of the user has set a time zone
    time_zone = valid_time_zone?(time_zone) ? time_zone : current_user.brand.try(:tz).to_s
    # Default to the current time zone if none are valid
    time_zone = valid_time_zone?(time_zone) ? time_zone : Time.zone.name
    Time.use_zone(time_zone, &block)
  end

  # @return [Boolean]
  def valid_time_zone?(time_zone)
    !ActiveSupport::TimeZone.new(time_zone).nil?
  end
end

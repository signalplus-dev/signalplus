class Webhooks::Stripe::BaseController < ApplicationController
  include StripeWebhookEvents
  
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session

  before_action :validate_request
  before_action :validate_event_type
  before_action :validate_event_environment if Rails.env.production?

  rescue_from Stripe::APIConnectionError, with: :stripe_error
  rescue_from Stripe::StripeError, with: :stripe_error

  def stripe_error
    head status: 200
  end

  protected  

  def validate_event_type
    if !StripeWebhookEvents::VALUES.include?(params[:type])
      stripe_error
    end
  end

  def validate_event_environment
    stripe_error unless params[:data][:object][:livemode]
  end

  def validate_request
    stripe_error unless authenticate == true
  end

  def authenticate
    authenticate_or_request_with_http_basic('Stripe Webhook') do |username, password|
      username == 'user' && password == 'password'
    end
  end
end

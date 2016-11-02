class Webhooks::Stripe::BaseController < ApplicationController
  include StripeWebhookEvents

  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session

  before_action :authenticate
  before_action :validate_event_type
  before_action :validate_event_environment if Rails.env.production?

  rescue_from Stripe::APIConnectionError, with: :stripe_error
  rescue_from Stripe::StripeError, with: :stripe_error


  # TODO: 
  # Return 4XX/5XX if Event Processing Fails
  # Return 200 if not able to locate event from Stripe API
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

  def authenticate
    authenticate_or_request_with_http_basic('Stripe Webhook') do |username, password|
      username == ENV['STRIPE_WEBHOOK_USER'] && password == ENV['STRIPE_WEBHOOK_PW']
    end
  end
end

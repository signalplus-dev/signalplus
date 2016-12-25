class Webhooks::Stripe::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session

  before_action :authenticate
  before_action :validate_event_environment if Rails.env.production?
  before_action :get_event

  rescue_from Stripe::APIConnectionError, with: :stripe_error
  rescue_from Stripe::StripeError, with: :stripe_error

  def index
    StripeWebhookHandler.new(@event).handle_webhook
    head :ok
  end


  # TODO:
  # Return 4XX/5XX if Event Processing Fails
  # Return 200 if not able to locate event from Stripe API
  def stripe_error
    head :ok
  end

  protected

  def validate_event_environment
    stripe_error unless params[:data][:object][:livemode]
  end

  def authenticate
    authenticate_or_request_with_http_basic('Stripe Webhook') do |username, password|
      username == ENV['STRIPE_WEBHOOK_USER'] && password == ENV['STRIPE_WEBHOOK_PW']
    end
  end

  def get_event
    @event = Stripe::Event.retrieve(params[:id])
  end

  def should_ssl?
    false
  end
end

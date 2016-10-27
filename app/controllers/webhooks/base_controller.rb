class Webhooks::BaseController < ApplicationController
  rescue_from ApiErrors::StandardError, with: :stripe_error
  rescue_from Stripe::APIConnectionError, Stripe::StripeError, with: :stripe_error

  include StripeWebhookEvents

  def stripe_error
    head :ok, status: 400
  end

  def validate_event_type
    if !StripeWebhookEvents.values.include?(params[:type])
      raise ApiErrors::StandardError
    end
  end
end

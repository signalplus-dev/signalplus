class Webhooks::StripeWebhooksController < Webhooks::BaseController
  rescue_from WebhookErrors::StandardError, with: :stripe_error
  rescue_from Stripe::APIConnectionError, with: :stripe_error
  rescue_from Stripe::StripeError, with: :stripe_error

  include StripeWebhookEvents

  def stripe_error
    head status: 200
  end

  def validate_event_type
    if !StripeWebhookEvents::VALUES.include?(params[:type])
      raise WebhookErrors::StandardError
    end
  end
end

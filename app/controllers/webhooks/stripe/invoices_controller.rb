class Webhooks::Stripe::InvoicesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create, :update

  def create
    event = Stripe::Event.retrieve(params[:id])
    InvoiceHandler.create_invoice

    render nothing: true, status: 201
  rescue Stripe::APIConnectionError, Stripe::StripeError
    render nothing: true, status: 400
  end

  def update
  end
end

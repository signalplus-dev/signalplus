class Webhooks::Stripe::InvoicesController < Webhooks::BaseController
  skip_before_action :verify_authenticity_token, only: [:create, :charge_event]
  before_action :validate_event_type, only: [:create, :charge_event] 

  def create
    event = get_event(params)
    invoice_handler = InvoiceHandler.new(event)
    invoice_handler.create_invoice!

    head :ok, status: 202
  end

  def charge_event
    event = get_event(params)
    invoice_handler = InvoiceHandler.new(event)
    invoice_handler.update_invoice_paid_timestamp!
    
    head :ok, status: 202
  end

  private

  def get_event(params)
    Stripe::Event.retrieve(params[:id])
  end
end

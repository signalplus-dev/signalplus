class Webhooks::Stripe::InvoicesController < Webhooks::Stripe::BaseController
  def create
    invoice_handler = InvoiceHandler.new(get_event_data(params))
    invoice_handler.create_invoice!

    head :ok, status: 200
  end

  def charge_event
    invoice_handler = InvoiceHandler.new(get_event_data(params))
    invoice_handler.update_invoice_paid_timestamp!
    
    head :ok, status: 200
  end

  private

  def get_event_data(params)
    event = Stripe::Event.retrieve(params[:id])
    return event.data.object if event.present?
  end
end

class InvoiceHandler
  def initialize(event)
    @invoice = event.data.object
  end

  def create_invoice!
    begin
    	Invoice.create!(
        brand:              get_brand,
        stripe_invoice_id:  @invoice.id,
        amount:             @invoice.amount_due,
        data:               @invoice,
        paid_at:            Time.now.utc
      )
    rescue Stripe::InvalidRequestError => e
      Rollbar.error(e)
    end
  end

  def update_invoice_paid_timestamp!
    invoice = Invoice.find(stripe_invoice_id: @invoice.id)
    timestamp = Time.at(@invoice.date).to_formatted_s(:db)

    invoice.update!(paid_at: timestamp)

  rescue ActiveRecord::RecordNotFound => e
    Rollbar.error(e)
  end

  private

  def get_brand
    email = Stripe::Customer.retrieve(id: @invoice.customer).try(:email)
    User.find_by_email(email).brand
  end
end

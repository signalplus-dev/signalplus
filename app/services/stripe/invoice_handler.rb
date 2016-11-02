class InvoiceHandler

  # @param [Hash] Stripe Webhook Invoice Payload
  # @return [InvoiceHandler] 
  def initialize(invoice_data)
    @invoice_data= invoice_data
  end

  def create_invoice!
  	Invoice.create!(
      brand:              get_brand,
      stripe_invoice_id:  @invoice_data.id,
      amount:             @invoice_data.amount_due,
      data:               @invoice_data
    )
  end

  def update_invoice_paid_timestamp!
    invoice = Invoice.find_by(stripe_invoice_id: @invoice_data.id)
    timestamp = Time.at(@invoice_data.date).to_formatted_s(:db)

    invoice.update!(paid_at: timestamp) if invoice.present?
  end

  private

  def get_brand
    brand_id = PaymentHandler.where(token: @invoice_data.customer).pluck(:brand_id).first
    raise StandardError.new('Could not find PaymentHandler for that customer')  unless brand_id
  end
end

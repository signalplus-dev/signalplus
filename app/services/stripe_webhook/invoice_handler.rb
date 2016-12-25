class StripeWebhook::InvoiceHandler < StripeWebhook::BaseHandler
  def created
  	Invoice.create!(
      brand_id:          get_brand_id,
      stripe_invoice_id: data_object.id,
      amount:            data_object.amount_due,
      data:              data_object,
    )
  end

  def payment_succeeded
    invoice = Invoice.find_by(stripe_invoice_id: data_object.id)
    timestamp = Time.at(data_object.date).to_formatted_s(:db)
    invoice.update!(paid_at: timestamp) if invoice.present?
  end

  private

  def get_brand_id
    brand_id = PaymentHandler.where(token: data_object.customer).pluck(:brand_id).first
    raise StandardError.new('Could not find PaymentHandler for that customer') unless brand_id
    brand_id
  end
end

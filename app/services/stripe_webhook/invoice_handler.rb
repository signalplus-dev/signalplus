class StripeWebhook::InvoiceHandler < StripeWebhook::BaseHandler
  def created
  	Invoice.create!(
      brand_id:          get_brand_id,
      stripe_invoice_id: data_object.id,
      amount:            data_object.amount_due,
      data:              data_object,
      period_start:      Time.at(data_object.period_start),
      period_end:        Time.at(data_object.period_end),
    )
  rescue ActiveRecord::RecordNotUnique
    # Don't do anything; record has already been saved
  end

  def payment_succeeded
    if invoice.present?
      timestamp = Time.at(event.created)

      invoice.update!(
        paid_at:        timestamp,
        amount:         data_object.amount_due,
        data:           data_object,
        payment_failed: false,
      )
    end
  end

  def payment_failed
    if invoice.present?
      invoice.update!(
        amount:         data_object.amount_due,
        data:           data_object,
        payment_failed: true,
      )
    end
  end

  def updated
    if invoice.present?
      invoice.update!(
        amount: data_object.amount_due,
        data:   data_object,
      )
    end
  end

  private

  def get_brand_id
    brand_id = PaymentHandler.where(token: data_object.customer).pluck(:brand_id).first
    raise StandardError.new('Could not find PaymentHandler for that customer') unless brand_id
    brand_id
  end

  def invoice
    @invoice ||= Invoice.find_by(stripe_invoice_id: data_object.id)
  end
end

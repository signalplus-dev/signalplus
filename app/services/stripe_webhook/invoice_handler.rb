class StripeWebhook::InvoiceHandler < StripeWebhook::BaseHandler
  def created
    brand_id = get_brand_id

    if should_raise_error?(brand_id)
      raise StandardError.new('Could not find PaymentHandler for that customer')
    end

    unless brand_id
      Invoice.create!(
        brand_id:          brand_id,
        stripe_invoice_id: data_object.id,
        amount:            data_object.amount_due,
        data:              data_object,
        period_start:      Time.at(data_object.period_start),
        period_end:        Time.at(data_object.period_end),
      )
    end
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
    PaymentHandler.where(token: data_object.customer).pluck(:brand_id).first
  end

  def invoice
    @invoice ||= Invoice.find_by(stripe_invoice_id: data_object.id)
  end

  # TODO - remove afterwards; we're currently raising errors because of webhooks being
  # sent for local dev testing accounts
  def should_raise_error?(brand_id)
    return false if brand_id
    return true  if event.livemode
    !event.livemode && !Rails.env.production?
  end
end

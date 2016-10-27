module StripeWebhookEvents
  INVOICE_CREATED_EVENT = 'invoice.created'
  INVOICE_CHARGE_SUCCESS_EVENT = 'invoice.payment_succeeded'

  def self.values
    values = []
    self.constants.each do |key|
      values.push(self.const_get(key))
    end
    values
  end
end

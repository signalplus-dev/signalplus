class InvoicePayment
  def initialize(event: event)
    @invoice = event.data.object
  end

  # def process
  #   charge.update_column(processed_at: Time.zone.now)
  #   ChargeMailer.confirmation(charge).deliver_later
  # end

  def create!
  	
  	normalized_payload = normalize_invoice_payload
  end

  private

  def normalize_invoice_payload
  	@invoice.map do
  end

  # def charge
  #   @invoice ||= Charge.where(stripe_charge_id: @stripe_charge.id).first!
  # end
end

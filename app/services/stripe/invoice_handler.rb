class InvoiceHandler
  def initialize(event: event)
    @invoice = event.data.object
    @brand = get_brand
  end

  def create_invoice
    if @brand
    	Invoice.create!(
        invoice_id: @invoice.id,
        brand: @brand,
        data: @invoice,
        amount: @amount,
        paid: 
        attempts: 
      )
    else 
      # Need to raise an error here which one?
      raise 'error'
    end
  end

  def update_invoice_status
  end

  private

  def get_brand
    email = Stripe::Customer.retrieve(id: @invoice.customer).email
    User.find_by_email(email).try(:brand)
  end
end

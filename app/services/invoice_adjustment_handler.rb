class InvoiceAdjustmentHandler
  attr_reader :brand, :old_plan, :new_plan

  # @param brand_id [Brand]
  # @param old_plan [SubscriptionPlan]
  # @param new_plan [SubscriptionPlan]
  def initialize(brand, old_plan, new_plan)
    @brand    = brand
    @old_plan = old_plan
    @new_plan = new_plan
  end

  def adjust!
    if affected_invoice
      remove_proration_stripe_invoice_items!

      if amount_to_charge > 0
        stripe_invoice_item = create_stripe_invoice_item!
        InvoiceAdjustment.create_adjustment!(affected_invoice, stripe_invoice_item)
      end
    end
  rescue Stripe::InvalidRequestError => e
    raise unless e.http_status == 404
  end

  private

  # @return [Invoice]
  def affected_invoice
    @affected_invoice ||= brand.last_subscription_invoice
  end

  # @return [Stripe::ListObject]
  def upcoming_invoice_items
    @upcoming_invoice_items ||= brand.stripe_customer.invoice_items
  end

  # @return [Array<String>]
  def proration_line_item_ids
    upcoming_invoice_items.data.select(&:proration).map(&:id)
  end

  def remove_proration_stripe_invoice_items!
    proration_line_item_ids.each do |invoice_item_id|
      Stripe::InvoiceItem.retrieve(invoice_item_id).delete
    end
  end

  # @return [Fixnum]
  def amount_to_charge
    @amount_to_charge ||= new_plan.amount - affected_invoice.total_adjusted_amount
  end

  def create_stripe_invoice_item!
    Stripe::InvoiceItem.create(
      customer:     brand.stripe_customer_token,
      amount:       amount_to_charge,
      currency:     new_plan.currency,
      description:  invoice_item_description,
      subscription: brand.stripe_subscription_token,
    )
  end

  # @return [String]
  def invoice_item_description
    "Charge for upgrading from #{old_plan.name} Plan to #{new_plan.name} Plan"
  end
end

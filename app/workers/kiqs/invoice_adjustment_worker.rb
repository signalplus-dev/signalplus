class InvoiceAdjustmentWorker
  include Sidekiq::Worker

  # Since this could potentially charge customers multiple times,
  # deal with errors manually for now
  sidekiq_options :retry => false

  # @param brand_id    [Fixnum]
  # @param old_plan_id [Fixnum]
  # @param new_plan_id [Fixnum]
  def perform(brand_id, old_plan_id, new_plan_id)
    brand    = Brand.find(brand_id)
    old_plan = SubscriptionPlan.find(old_plan_id)
    new_plan = SubscriptionPlan.find(new_plan_id)
    handler  = InvoiceAdjustmentHandler.new(brand, old_plan, new_plan)

    handler.adjust!
  end
end

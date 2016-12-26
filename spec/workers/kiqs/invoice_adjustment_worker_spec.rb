require 'rails_helper'
require 'shared/stripe'

describe InvoiceAdjustmentWorker do
  let(:worker)   { described_class.new }
  let(:brand)    { create(:brand) }
  let(:old_plan) { SubscriptionPlan.basic }
  let(:new_plan) { SubscriptionPlan.advanced }

  before do
    expect_any_instance_of(InvoiceAdjustmentHandler).to receive(:adjust!)
  end

  it 'should try to adjust the invoices' do
    expect(InvoiceAdjustmentHandler).to receive(:new).with(
      brand,
      old_plan,
      new_plan
    ).and_call_original
    worker.perform(brand.id, old_plan.id, new_plan.id)
  end
end

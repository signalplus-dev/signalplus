require 'rails_helper'
require 'shared/stripe'

describe InvoiceAdjustment do
  include_context 'invoice created'

  let(:invoice)  { Invoice.first }
  let(:old_plan) { create(:subscription_plan) }
  let(:new_plan) { create(:subscription_plan, :advanced) }
  let(:invoice_item) do
    InvoiceAdjustmentHandler.new(brand, old_plan, new_plan).send(:create_stripe_invoice_item!)
  end

  describe '.create_adjustment!' do
    it 'creates an invoice adjustment' do
      expect {
        described_class.create_adjustment!(invoice, invoice_item)
      }.to change {
        InvoiceAdjustment.count
      }.from(0).to(1)
    end
  end
end

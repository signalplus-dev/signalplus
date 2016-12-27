# == Schema Information
#
# Table name: invoice_adjustments
#
#  id                     :integer          not null, primary key
#  invoice_id             :integer          not null
#  stripe_invoice_item_id :string           not null
#  data                   :jsonb            not null
#  amount                 :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'
require 'shared/stripe'

describe InvoiceAdjustment do
  include_context 'invoice created'

  let(:invoice)  { Invoice.first }
  let(:old_plan) { SubscriptionPlan.basic }
  let(:new_plan) { SubscriptionPlan.advanced }
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

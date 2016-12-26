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

class InvoiceAdjustment < ApplicationRecord
  belongs_to :invoice

  class << self
    # @param invoice             [Invoice]
    # @param stripe_invoice_item [Stripe::InvoiceItem]
    # @return                    [InvoiceAdjustment]
    def create_adjustment!(invoice, stripe_invoice_item)
      create!(
        invoice:                invoice,
        stripe_invoice_item_id: stripe_invoice_item.id,
        amount:                 stripe_invoice_item.amount,
        data:                   stripe_invoice_item.as_json,
      )
    end
  end
end

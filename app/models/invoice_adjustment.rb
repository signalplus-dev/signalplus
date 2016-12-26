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
  belongs :invoice
end

# == Schema Information
#
# Table name: invoices
#
#  id                :integer          not null, primary key
#  stripe_invoice_id :string
#  brand_id          :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  paid_at           :datetime
#  amount            :integer
#  data              :jsonb            not null
#

class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :stripe_invoice_id, :amount, :paid_at, :created_at, :data
end

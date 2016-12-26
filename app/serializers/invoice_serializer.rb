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
#  period_start      :datetime
#  period_end        :datetime
#

class InvoiceSerializer < ActiveModel::Serializer
  attributes :id,
             :stripe_invoice_id,
             :amount,
             :paid_at,
             :period_start,
             :period_end,
             :data

  def data
    object.normalize_data
  end
end

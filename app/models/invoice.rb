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

class Invoice < ActiveRecord::Base
  belongs_to :brand


  def normalize_data
    invoice = self.data['data']['object']
    return unless invoice.present?

    {
      amount_due: invoice['amount_due'],
      paid: invoice['paid'],
      total: invoice['total'],
      line_items: invoice['lines']['data'].map do |l|
         { amount: l['amount'], period: l['period'] }
      end
    }
  end
end

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
    return unless self.data.key?('data') && self.data.key?('object')

    invoice = self.data['data']['object']

    {
      period_start: invoice['period_start'],
      period_end: invoice['period_end'],
      amount_due: invoice['amount_due'],
      paid: invoice['paid'],
      total: invoice['total'],
      line_items: normalize_line_items(invoice)
    }
  end

  def normalize_line_items(invoice)
    return unless invoice.key?('lines')

    invoice['lines']['data'].map do |l|
      { 
        amount: l['amount'], 
        period: l['period'],
        plan_name: l['plan']['name']
      }
    end
  end
end

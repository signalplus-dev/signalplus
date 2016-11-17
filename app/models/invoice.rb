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
    {
      period_start: data['period_start'],
      period_end: data['period_end'],
      amount_due: data['amount_due'],
      paid: data['paid'],
      total: data['total'],
      line_items: normalize_line_items(data)
    }
  end

  def normalize_line_items(data)
    data['lines']['data'].map do |l|
      { 
        amount: l['amount'], 
        period: l['period'],
        plan_name: l['plan']['name']
      }
    end
  end
end

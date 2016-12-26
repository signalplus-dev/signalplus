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

require 'rails_helper'

describe Invoice do
  describe '#normalize_data' do 

    context 'with json data' do
      let(:invoice_json_data) { File.read('spec/factories/invoice_data.json') }
      let(:invoice) { create(:invoice, data: JSON.parse(invoice_json_data)['data']['object']) } 

      it 'returns normalized_data' do
        normalized_data = invoice.normalize_data
        expect(normalized_data).to include({
          period_start: 1394018368,
          period_end: 1394018368,
          amount_due: 0,
          paid: true,
          total: 30000,
          line_items: [
            {:amount=>19000, :period=>{"start"=>1393765661, "end"=>1393765661}, :plan_name=>"Basic"}, 
            {:amount=>-9000, :period=>{"start"=>1393765661, "end"=>1393765661}, :plan_name=>"Premium"}, 
            {:amount=>20000, :period=>{"start"=>1383759053, "end"=>1386351053}, :plan_name=>"Basic"}
          ]
        })
      end
    end
  end
end

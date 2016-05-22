# == Schema Information
#
# Table name: listen_signals
#
#  id              :integer          not null, primary key
#  brand_id        :integer
#  identity_id     :integer
#  name            :text
#  expiration_date :datetime
#  active          :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe ListenSignal do
  describe '#response' do
    let(:response_group) { create(:response_group_with_responses) }
    let(:listen_signal) { create(:listen_signal) }

    context 'when signal is active' do
      it 'returns next resonse' do
        expect(listen_signal.response_group).to receive(:next_response).with('testhashtag')
        listen_signal.response('testhashtag')
      end
    end

    context 'when signal is expired' do
      let(:listen_signal) { create(:listen_signal, :expired) }

      it 'returns expired response' do
        expect(listen_signal.response_group).to receive(:expired_response)
        listen_signal.response('testhashtag')
      end
    end
  end
end
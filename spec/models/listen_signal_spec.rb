# == Schema Information
#
# Table name: listen_signals
#
#  id              :integer          not null, primary key
#  brand_id        :integer
#  identity_id     :integer
#  name            :text
#  expiration_date :datetime
#  active          :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  signal_type     :string
#

require 'rails_helper'

describe ListenSignal do
  let(:response_group) { create(:response_group_with_responses) }

  describe '#response' do
    let(:listen_signal)  { create(:listen_signal, :offer, response_group: response_group) }

    context 'when signal is active' do
      it 'returns next resonse' do
        expect(listen_signal.response_group).to receive(:next_response).with('testhashtag')
        listen_signal.response('testhashtag')
      end
    end

    context 'when signal is expired' do
      let(:listen_signal) { create(:listen_signal, :offer, :expired, response_group: response_group) }

      it 'returns expired response' do
        expect(listen_signal.response_group).to receive(:expired_response)
        listen_signal.response('testhashtag')
      end
    end
  end

  describe '.first_response' do
    let(:response_group) { create(:response_group_first_and_repeat_responses)}
    let(:listen_signal) { create(:listen_signal, :offer, response_group: response_group) }

    it 'returns first response' do
      first_response = listen_signal.first_response
      expect(first_response.priority).to eq(1)
    end
  end

  describe '.repeat_response' do
    let(:response_group) { create(:response_group_first_and_repeat_responses)}
    let(:listen_signal) { create(:listen_signal, :offer, response_group: response_group) }

    it 'returns repeat response' do
      repeat_response = listen_signal.repeat_response
      expect(repeat_response.priority).to eq(2)
    end
  end
end

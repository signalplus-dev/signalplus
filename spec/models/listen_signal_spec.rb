# == Schema Information
#
# Table name: listen_signals
#
#  id              :integer          not null, primary key
#  brand_id        :integer
#  identity_id     :integer
#  name            :text
#  active          :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  signal_type     :string
#  expiration_date :datetime
#  deleted_at      :datetime
#

require 'rails_helper'

describe ListenSignal do
  let(:response_group) { create(:default_group_responses) }

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
    let(:response_group) { create(:default_group_responses) }
    let(:listen_signal) { create(:listen_signal, :offer, response_group: response_group) }

    it 'returns repeat response' do
      repeat_response = listen_signal.repeat_response
      expect(repeat_response.priority).to eq(1000)
    end
  end

  describe 'validates_uniqueness_of :name' do
    let(:listen_signal_1)  { create(:listen_signal) }
    let(:listen_signal_2) { ListenSignal.new(listen_signal_1.as_json.except('id', 'deleted_at')) }

    it 'does not allow for having 2 signals with the same name' do
      expect { listen_signal_2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'will allow the same name if the other signal is deleted' do
      listen_signal_1.destroy
      expect { listen_signal_2.save! }.to_not raise_error
    end
  end

  describe '#destroy' do
    let(:listen_signal) { create(:listen_signal, :offer, response_group: response_group) }
    let!(:promotional_tweet) { create(:promotional_tweet, listen_signal: listen_signal) }

    before  { listen_signal.destroy }

    context 'the deleted listen signal' do
      subject { listen_signal }
      it      { is_expected.to be_deleted_at }
    end

    context 'the deleted response group' do
      subject { listen_signal.response_group }
      it      { is_expected.to be_deleted_at }
    end

    context 'the deleted responses' do
      subject { listen_signal.responses.with_deleted }
      it      { is_expected.to_not be_empty }
      it      { is_expected.to all( be_deleted_at ) }
    end

    context 'the deleted promotional tweets' do
      subject { listen_signal.promotional_tweets.with_deleted }
      it      { is_expected.to_not be_empty }
      it      { is_expected.to all( be_deleted_at ) }
    end
  end
end

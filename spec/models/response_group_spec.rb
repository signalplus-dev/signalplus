# == Schema Information
#
# Table name: response_groups
#
#  id               :integer          not null, primary key
#  listen_signal_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

describe ResponseGroup do
  describe '#next_response' do
    let(:identity)       { create(:identity) }
    let(:response_group) { create(:response_group_with_responses) }
    let(:listen_signal)  { create(:listen_signal, response_group: response_group, brand: identity.brand, identity: identity) }

    it 'returns prioritized unsent response' do
      expect(response_group.next_response('randomtwitterhandle'))
        .to eq(response_group.responses.first)
    end

    context 'has sent responses' do
      it 'filters out sent responses' do
        create(:twitter_response, :replied, listen_signal: listen_signal, response: response_group.responses.first)
        expect(response_group.next_response('randomtwitterhandle'))
          .not_to eq(response_group.responses.first)
      end
    end
  end

  # describe '#default_response' do
  #   let(:identity) { create(:identity) }
  #   let(:listen_signal) { create(:listen_signal, brand: identity.brand, identity: identity) }
  #   let(:response_group) { create(:response_group_with_responses, listen_signal: listen_signal) }

  #   it 'returns ' do
  #   end
  # end

  describe '#expired_response' do
    let(:identity)       { create(:identity) }
    let(:listen_signal)  { create(:listen_signal, :expired, brand: identity.brand, identity: identity) }
    let(:response_group) { create(:response_group_with_responses, listen_signal: listen_signal) }

    it 'returns expired message' do
      expired_msg = response_group.expired_response
      expect(expired_msg.response_type).to eq('expired')
    end
  end
end

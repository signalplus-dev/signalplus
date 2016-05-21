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
    let(:identity) { create(:identity) }
    let(:listen_signal) { create(:listen_signal, brand: identity.brand, identity: identity) }
    let(:response_group) { create(:response_group_with_responses, listen_signal: listen_signal) }

    it 'returns prioritized unsent response' do
      expect(response_group.next_response('randomtwitterhandle'))
        .to eq(response_group.responses.first)
    end

    context 'has sent responses' do
      let(:twitter_response) {
        create(:twitter_response, listen_signal_id: listen_signal.id,
              response_id: response_group.responses.first)
      }
      it 'filters out sent responses' do
        expect(response_group.next_response('randomtwitterhandle'))
          .not_to eq(response_group.responses.first)
      end
    end
  end
end

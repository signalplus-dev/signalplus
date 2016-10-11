# == Schema Information
#
# Table name: response_groups
#
#  id               :integer          not null, primary key
#  listen_signal_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#

require 'rails_helper'

describe ResponseGroup do
  describe '#next_response' do
    before do
      allow_any_instance_of(TwitterResponse).to receive(:should_increment_response_count?).and_return(false)
    end

    let(:identity)       { create(:identity) }
    let(:response_group) { create(:default_group_responses) }
    let(:listen_signal)  { create(:listen_signal, response_group: response_group, brand: identity.brand, identity: identity) }

    it 'returns prioritized unsent response' do
      expect(response_group.next_response('randomtwitterhandle'))
        .to eq(response_group.default_response)
    end

    context 'has sent responses' do
      it 'filters out sent responses' do
        create(:twitter_response, :replied, listen_signal: listen_signal, response: response_group.responses.first)
        expect(response_group.next_response('randomtwitterhandle'))
          .not_to eq(response_group.default_response)
      end
    end

    context 'a different day' do
      before do
        # freeze current time
        current_time = Time.current
        stub_current_time(current_time)
      end

      it 'allows for sending a default response on a different day' do
        create(:twitter_response, :replied, listen_signal: listen_signal, response: response_group.responses.first)
        stub_current_time(Time.current + 1.day)
        expect(response_group.next_response('randomtwitterhandle'))
          .to eq(response_group.default_response)
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

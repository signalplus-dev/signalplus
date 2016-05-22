require 'rails_helper'

describe Responders::Twitter::DirectMessageReply do
  let(:identity)        { create(:identity) }
  let(:brand)           { identity.brand }
  let!(:listen_signal)  { create(:listen_signal, brand: brand, identity: identity) }
  let!(:response_group) { create(:response_group_with_responses, listen_signal: listen_signal) }
  let(:direct_message)  { example_twitter_direct_message }

  describe '.as_json' do
    before do
      # Freeze time
      time = Time.current
      stub_current_time(time)
    end

    subject { described_class.new(brand: brand, message: direct_message, listen_signal: listen_signal).as_json }

    its('keys.size') { is_expected.to eq(7) }

    it { is_expected.to include(date: Date.current.to_s) }
    it { is_expected.to include(brand_id: brand.id) }
    it { is_expected.to include(to: 'fishbowl1551') }
    it { is_expected.to include(listen_signal_id: listen_signal.id) }
    it { is_expected.to include(request_tweet_id: 723732623017824259) }
    it { is_expected.to include(request_tweet_type: 'DirectMessage') }
  end
end

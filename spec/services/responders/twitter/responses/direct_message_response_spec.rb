require 'rails_helper'

describe Responders::Twitter::DirectMessageResponse do
  let(:brand)          { create(:brand) }
  let(:direct_message) { example_twitter_direct_message }
  let(:hashtag)        { direct_message.hashtags.first.text }

  describe '.as_json' do
    before do
      # Freeze time
      time = Time.current
      stub_current_time(time)
    end

    subject { described_class.new(brand, direct_message, hashtag).as_json }

    its('keys.size') { is_expected.to eq(6) }

    it { is_expected.to include(date: Date.current.to_s) }
    it { is_expected.to include(from: 'Nike') }
    it { is_expected.to include(to: 'fishbowl1551') }
    it { is_expected.to include(hashtag: 'somehashtag') }
    it { is_expected.to include(response_id: 723732623017824259) }
    it { is_expected.to include(response_type: 'DirectMessage') }
  end
end

require 'rails_helper'

describe Responders::Twitter::Response do
  let(:brand)          { create(:brand) }
  let(:tweet)          { example_twitter_tweet }
  let(:direct_message) { example_twitter_direct_message }

  describe '.build' do
    context 'with a tweet' do
      subject { described_class.build(brand, tweet, 'somehashtag') }
      it      { is_expected.to be_a(Responders::Twitter::TweetResponse) }
    end

    context 'with a direct message' do
      subject { described_class.build(brand, direct_message, 'somehashtag') }
      it      { is_expected.to be_a(Responders::Twitter::DirectMessageResponse) }
    end

    context 'with a different object' do
      it 'raises an error' do
        expect {
          described_class.build(brand, 'Not a supported object', 'somehashtag')
        }.to raise_error(ArgumentError)
      end
    end
  end
end

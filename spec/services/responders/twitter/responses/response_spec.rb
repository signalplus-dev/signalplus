require 'rails_helper'

describe Responders::Twitter::Response do
  let(:brand)          { create(:brand) }
  let(:tweet)          { example_twitter_tweet }
  let(:direct_message) { example_twitter_direct_message }

  describe '.build' do
    context 'with a tweet' do
      subject { described_class.build(brand: brand, message: tweet, hashtag: 'somehashtag') }
      it      { is_expected.to be_a(Responders::Twitter::TweetResponse) }
    end

    context 'with a direct message' do
      subject { described_class.build(brand: brand, message: direct_message, hashtag: 'somehashtag') }
      it      { is_expected.to be_a(Responders::Twitter::DirectMessageResponse) }
    end

    context 'with a different object' do
      it 'raises an error' do
        expect {
          described_class.build(brand: brand, message: 'Not a supported object', hashtag: 'somehashtag')
        }.to raise_error(ArgumentError)
      end
    end
  end
end

require 'rails_helper'

describe Responders::Twitter::Reply do
  let(:identity)       { create(:identity) }
  let(:brand)          { identity.brand }
  let!(:listen_signal) { create(:listen_signal, brand: brand, identity: identity) }
  let(:tweet)          { example_twitter_tweet }
  let(:direct_message) { example_twitter_direct_message }

  describe '.build' do
    context 'with a tweet' do
      subject { described_class.build(brand: brand, message: tweet, listen_signal: listen_signal) }
      it      { is_expected.to be_a(Responders::Twitter::TweetReply) }
    end

    context 'with a direct message' do
      subject { described_class.build(brand: brand, message: direct_message, listen_signal: listen_signal) }
      it      { is_expected.to be_a(Responders::Twitter::DirectMessageReply) }
    end

    context 'with a different object' do
      it 'raises an error' do
        expect {
          described_class.build(brand: brand, message: 'Not a supported object', listen_signal: listen_signal)
        }.to raise_error(ArgumentError)
      end
    end
  end
end

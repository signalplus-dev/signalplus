require 'rails_helper'

describe Responders::Twitter::Filter do
  let(:identity)      { create(:identity) }
  let(:brand)         { identity.brand }
  let!(:listen_signal) { create(:listen_signal, brand: brand, identity: identity) }

  describe '#out_multiple_requests!' do
    context 'with a mix of direct messges and tweets' do
      let(:tweet_messages) { [example_twitter_tweet, example_twitter_direct_message] }

      subject { described_class.new(brand, tweet_messages) }

      it 'filters out multiple requests' do
        expect {
          subject.out_multiple_requests!
        }.to change {
          subject.grouped_replies[listen_signal.id].size
        }.from(2).to(1)
      end
    end

    context 'with just tweets' do
      let(:tweet_messages) { [example_twitter_tweet, example_twitter_tweet] }

      subject { described_class.new(brand, tweet_messages) }

      it 'filters out multiple requests' do
        expect {
          subject.out_multiple_requests!
        }.to change {
          subject.grouped_replies[listen_signal.id].size
        }.from(2).to(1)
      end
    end

    context 'with just direct messages' do
      let(:tweet_messages) { [example_twitter_direct_message, example_twitter_direct_message] }

      subject { described_class.new(brand, tweet_messages) }

      it 'filters out multiple requests' do
        expect {
          subject.out_multiple_requests!
        }.to change {
          subject.grouped_replies[listen_signal.id].size
        }.from(2).to(1)
      end
    end
  end

  describe '#out_users_already_replied_to!' do
    let(:tweet_message) { example_twitter_direct_message }
    subject             { described_class.new(brand, tweet_message) }

    before { TwitterResponse.create(subject.grouped_replies[listen_signal.id].first.as_json) }

    it 'filters out replies for users that have already been replied to' do
      expect {
        subject.out_users_already_replied_to!
      }.to change {
        subject.grouped_replies[listen_signal.id].size
      }.from(1).to(0)
    end
  end
end

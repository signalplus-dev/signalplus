require 'rails_helper'

describe UpdateTrackerWorker do
  let(:worker)        { described_class.new }
  let(:brand)         { create(:brand) }
  let(:tweet_tracker) { brand.tweet_tracker }

  context 'with an array of ids' do
    it 'updates the tracker' do
      expect {
        worker.perform(tweet_tracker.id, tweet_tracker.class.to_s, [5,4,3])
      }.to change {
        tweet_tracker.reload.since_id
      }.from(1).to(5)
    end
  end

  context 'with an id' do
    it 'updates the tracker' do
      expect {
        worker.perform(tweet_tracker.id, tweet_tracker.class.to_s, 6)
      }.to change {
        tweet_tracker.reload.since_id
      }.from(1).to(6)
    end
  end
end

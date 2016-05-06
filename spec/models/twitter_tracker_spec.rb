# == Schema Information
#
# Table name: twitter_trackers
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  last_recorded_tweet_id :integer          default(1)
#  since_id               :integer          default(1)
#  max_id                 :integer
#

require 'rails_helper'

describe TwitterTracker do
  let(:brand)         { create(:brand) }
  let(:tweet_tracker) { brand.tweet_tracker }

  context 'valid tweet tracker update' do
    it 'allows it being set to the same last_recorded_tweet_id' do
      expect(tweet_tracker).to be_valid
    end

    it 'allows you to increase the last_recorded_tweet_id' do
      tweet_tracker.last_recorded_tweet_id += 1
      expect(tweet_tracker).to be_valid
    end

    it 'updates the value in the db' do
      expect {
        tweet_tracker.update(last_recorded_tweet_id: tweet_tracker.last_recorded_tweet_id + 1)
      }.to change {
        tweet_tracker.reload.last_recorded_tweet_id
      }.from(1).to(2)
    end
  end

  context 'invalid tweet tracker' do
    before do
      tweet_tracker.last_recorded_tweet_id += 10
      tweet_tracker.save!
    end

    it 'does not allow you to decrease the last_recorded_tweet_id' do
      tweet_tracker.last_recorded_tweet_id -= 1
      expect(tweet_tracker).to be_invalid
    end

    context 'trying to update the tracker' do
      it 'fails to update the tracker' do
        expect {
          tweet_tracker.update(last_recorded_tweet_id: tweet_tracker.last_recorded_tweet_id - 1)
        }.to_not change {
          tweet_tracker.reload.last_recorded_tweet_id
        }
      end
    end
  end
end

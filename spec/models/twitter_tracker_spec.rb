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
    # Let's assume that Twitter, with their API, only responds with at most 20
  # tweet mentions at a time. That means that it's possible that after a set time
  # has passed since Twitter was last polled for mentions, more tweets could have
  # come in than can be processed during the next time we poll Twitter.
  # Thus, we need to keep track of the last recorded tweet id and 2 boundary condtions,
  # the since_id and the max_id, to be able to back track to those tweets that were not
  # processed during the last time we polled Twitter
  def set_tweet_list(first_id, last_id)
    (first_id..last_id).to_a.reverse.map do |id|
      double(:tweet, id: id)
    end
  end

  before { stub_const('TwitterListener::API_MENTIONS_TIMELINE_LIMIT', 20) }

  describe '.get_new_mentions_timeline_options' do
    context 'with the first pass of the tweet list' do
      context 'with less than the max amount that the API can reply back with' do
        it 'sets the since_id and the last_recorded_tweet_id' do
          tweet_list = set_tweet_list(1, 14)

          since_id,
          max_id,
          last_recorded_tweet_id = described_class.get_new_mentions_timeline_options(tweet_list, 1, 1)

          expect(since_id).to               eq(14)
          expect(max_id).to                 eq(nil)
          expect(last_recorded_tweet_id).to eq(14)
        end

        context 'with one tweet in the response' do
          it 'sets the since_id and the last_recorded_tweet_id' do
            tweet_list = set_tweet_list(668611843552866305, 668611843552866305)

            since_id,
            max_id,
            last_recorded_tweet_id = described_class.get_new_mentions_timeline_options(tweet_list, 1, 1)

            expect(since_id).to               eq(668611843552866305)
            expect(max_id).to                 eq(nil)
            expect(last_recorded_tweet_id).to eq(668611843552866305)
          end
        end
      end

      context 'with the max amount that the API can reply with' do
        it 'sets the since_id and the last_recorded_tweet_id' do
          tweet_list = set_tweet_list(1, 20)

          since_id,
          max_id,
          last_recorded_tweet_id = described_class.get_new_mentions_timeline_options(tweet_list, 1, 1)

          expect(since_id).to               eq(20)
          expect(max_id).to                 eq(nil)
          expect(last_recorded_tweet_id).to eq(20)
        end
      end
    end

    context 'after one pass' do
      context 'without more mentions than the max we get back from the API' do
        it 'sets a new since_id and last_recorded_tweet_id' do
          tweet_list = set_tweet_list(14, 33)

          since_id,
          max_id,
          last_recorded_tweet_id = described_class.get_new_mentions_timeline_options(tweet_list, 19, 19)

          expect(since_id).to               eq(33)
          expect(max_id).to                 eq(nil)
          expect(last_recorded_tweet_id).to eq(33)
        end
      end

      context 'with more mentions than the max we get back from the API' do
        it 'sets the last_recorded_tweet_id and the max_id but does not change the since_id' do
          tweet_list = set_tweet_list(30, 49)

          since_id,
          max_id,
          last_recorded_tweet_id = described_class.get_new_mentions_timeline_options(tweet_list, 19, 19)

          expect(since_id).to               eq(19)
          expect(max_id).to                 eq(29)
          expect(last_recorded_tweet_id).to eq(49)
        end

        context 'after getting more mentions than the max we get back from the API' do
          it 'changes the since_id to the last_recorded_tweet_id if given an empty array' do
            since_id,
            max_id,
            last_recorded_tweet_id = described_class.get_new_mentions_timeline_options([], 19, 49)

            expect(since_id).to               eq(49)
            expect(max_id).to                 eq(nil)
            expect(last_recorded_tweet_id).to eq(49)
          end

          it 'nils out the max_id and sets the since_id to the last_recorded_tweet_id' do
           tweet_list = set_tweet_list(20, 29)

            since_id,
            max_id,
            last_recorded_tweet_id = described_class.get_new_mentions_timeline_options(tweet_list, 19, 49)

            expect(since_id).to               eq(49)
            expect(max_id).to                 eq(nil)
            expect(last_recorded_tweet_id).to eq(49)
          end
        end

        context 'with no tweets since the last polling' do
          it 'does not change the since_id or the last_recorded_tweet_id' do
            since_id,
            max_id,
            last_recorded_tweet_id = described_class.get_new_mentions_timeline_options([], 49, 49)

            expect(since_id).to               eq(49)
            expect(max_id).to                 eq(nil)
            expect(last_recorded_tweet_id).to eq(49)
          end
        end
      end
    end
  end
end

require 'rails_helper'

describe TimelineHelper do
  # Let's assume that Twitter, with their API, only responds with at most 20
  # tweet mentions at a time. That means that it's possible that after a set time
  # has passed since Twitter was last polled for mentions, more tweets could have
  # come in than can be processed during the next time we poll Twitter.
  # Thus, we need to keep track of the last recorded tweet id and 2 boundary condtions,
  # the since_id and the max_id, to be able to back track to those tweets that were not
  # processed during the last time we polled Twitter
  def set_list_of_tweet_ids(first_id, last_id)
    (first_id..last_id).to_a.reverse
  end

  let(:api_timeline_limit) { 20 }

  describe '.get_new_timeline_options' do
    context 'with the first pass of the tweet list' do
      context 'with less than the max amount that the API can reply back with' do
        it 'sets the since_id and the last_recorded_tweet_id' do
          tweet_list = set_list_of_tweet_ids(1, 14)

          timeline_options = described_class.get_new_timeline_options(tweet_list, 1, 1, api_timeline_limit)

          expect(timeline_options).to include(since_id: 14)
          expect(timeline_options).to include(max_id: nil)
          expect(timeline_options).to include(last_recorded_tweet_id: 14)
        end

        context 'with one tweet in the response' do
          it 'sets the since_id and the last_recorded_tweet_id' do
            tweet_list = set_list_of_tweet_ids(668611843552866305, 668611843552866305)

            timeline_options = described_class.get_new_timeline_options(tweet_list, 1, 1, api_timeline_limit)

            expect(timeline_options).to include(since_id: 668611843552866305)
            expect(timeline_options).to include(max_id: nil)
            expect(timeline_options).to include(last_recorded_tweet_id: 668611843552866305)
          end
        end
      end

      context 'with the max amount that the API can reply with' do
        it 'sets the since_id and the last_recorded_tweet_id' do
          tweet_list = set_list_of_tweet_ids(1, 20)

          timeline_options = described_class.get_new_timeline_options(tweet_list, 1, 1, api_timeline_limit)

          expect(timeline_options).to include(since_id: 20)
          expect(timeline_options).to include(max_id: nil)
          expect(timeline_options).to include(last_recorded_tweet_id: 20)
        end
      end
    end

    context 'after one pass' do
      context 'without more mentions than the max we get back from the API' do
        it 'sets a new since_id and last_recorded_tweet_id' do
          tweet_list = set_list_of_tweet_ids(14, 33)

          timeline_options = described_class.get_new_timeline_options(tweet_list, 19, 19, api_timeline_limit)

          expect(timeline_options).to include(since_id: 33)
          expect(timeline_options).to include(max_id: nil)
          expect(timeline_options).to include(last_recorded_tweet_id: 33)
        end
      end

      context 'with more mentions than the max we get back from the API' do
        it 'sets the last_recorded_tweet_id and the max_id but does not change the since_id' do
          tweet_list = set_list_of_tweet_ids(30, 49)

          timeline_options = described_class.get_new_timeline_options(tweet_list, 19, 19, api_timeline_limit)

          expect(timeline_options).to include(since_id: 19)
          expect(timeline_options).to include(max_id: 29)
          expect(timeline_options).to include(last_recorded_tweet_id: 49)
        end

        context 'after getting more mentions than the max we get back from the API' do
          it 'changes the since_id to the last_recorded_tweet_id if given an empty array' do
            timeline_options = described_class.get_new_timeline_options([], 19, 49, api_timeline_limit)

            expect(timeline_options).to include(since_id: 49)
            expect(timeline_options).to include(max_id: nil)
            expect(timeline_options).to include(last_recorded_tweet_id: 49)
          end

          it 'nils out the max_id and sets the since_id to the last_recorded_tweet_id' do
           tweet_list = set_list_of_tweet_ids(20, 29)

            timeline_options = described_class.get_new_timeline_options(tweet_list, 19, 49, api_timeline_limit)

            expect(timeline_options).to include(since_id: 49)
            expect(timeline_options).to include(max_id: nil)
            expect(timeline_options).to include(last_recorded_tweet_id: 49)
          end
        end

        context 'with no tweets since the last polling' do
          it 'does not change the since_id or the last_recorded_tweet_id' do
            timeline_options = described_class.get_new_timeline_options([], 49, 49, api_timeline_limit)

            expect(timeline_options).to include(since_id: 49)
            expect(timeline_options).to include(max_id: nil)
            expect(timeline_options).to include(last_recorded_tweet_id: 49)
          end
        end
      end
    end
  end
end

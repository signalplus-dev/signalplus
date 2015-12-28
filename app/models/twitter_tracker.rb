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

class TwitterTracker < ActiveRecord::Base
  class << self
    # Processes the tweet list and keeps track of the max_id, the since_id
    # and the last_recorded_tweet_id.
    # @param tweets                 [Array] array of tweets
    # @param since_id               [Fixnum] the lower boundary of tweets to grab (exclusive)
    # @param last_recorded_tweet_id [Fixnum] keeps track of the id of the last tweet mention
    # @return                       [Array]  array containing the since_id, the max_id, and the last_recorded_tweet_id
    def get_new_mentions_timeline_options(tweets, since_id, last_recorded_tweet_id)
      return [last_recorded_tweet_id, nil, last_recorded_tweet_id] if tweets.empty?

      last_recorded_tweet_id       = [last_recorded_tweet_id, tweets.first.id].max
      lower_boundary_of_tweet_list = tweets.last.id

      if lower_boundary_of_tweet_list - 1 <= since_id || tweets.size < TwitterListener::API_MENTIONS_TIMELINE_LIMIT
        since_id = last_recorded_tweet_id
        max_id   = nil
      else
        max_id = lower_boundary_of_tweet_list - 1
      end

      [since_id, max_id, last_recorded_tweet_id]
    end
  end
end

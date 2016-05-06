module TimelineHelper
  API_TIMELINE_LIMIT = 200

  class << self
    # @param timeline_tracker [TwitterTracker|TwitterDirectMessageTracker]
    # @param ids              [Array<Fixnum|Bignum>] array of ids of tweets or direct messages
    def update_tracker!(timeline_tracker, ids)
      ids = ids.is_a?(Array) ? ids : [ids]

      updated_attributes = get_new_timeline_options(
        ids,
        timeline_tracker.since_id,
        timeline_tracker.last_recorded_tweet_id,
        API_TIMELINE_LIMIT
      )

      # Don't create noise when it fails validation; could have knowing
      # concurrency issues
      timeline_tracker.update(updated_attributes)
    end

    # Processes the tweet list and keeps track of the max_id, the since_id
    # and the last_recorded_tweet_id.
    # @param ids                    [Array<Fixnum|Bignum>] array of ids of tweets or direct messages
    # @param since_id               [Fixnum] the lower boundary of tweets to grab (exclusive)
    # @param last_recorded_tweet_id [Fixnum] keeps track of the id of the last tweet mention
    # @param max_api_limit          [Fixnum] the maximum number elements that can be returned at any time from
    #                                        the Twitter API.
    # @return                       [Hash]   hash containing the since_id, the max_id, and the last_recorded_tweet_id
    def get_new_timeline_options(ids, since_id, last_recorded_tweet_id, max_api_limit)
      if ids.empty?
        return {
          since_id:               last_recorded_tweet_id,
          max_id:                 nil,
          last_recorded_tweet_id: last_recorded_tweet_id
        }
      end

      last_recorded_tweet_id       = [last_recorded_tweet_id, ids.first].max
      lower_boundary_of_tweet_list = ids.last

      if lower_boundary_of_tweet_list - 1 <= since_id || ids.size < max_api_limit
        since_id = last_recorded_tweet_id
        max_id   = nil
      else
        max_id = lower_boundary_of_tweet_list - 1
      end

      {
        since_id:               since_id,
        max_id:                 max_id,
        last_recorded_tweet_id: last_recorded_tweet_id,
      }.with_indifferent_access
    end
  end
end

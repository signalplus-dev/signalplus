module Responders
  module Twitter
    class Listener
      HASHTAGS_TO_LISTEN_TO       = {
        'somehashtag' => {
          'text_response' => 'Check out this puppy!',
          'image'         => 'puppy_cuteness.gif',
        },
        'somehashtagwithoutimage' => {
          'text_response' => 'Check out this text response!',
        },
      }

      class << self
        def process_messages(brand_id)
          brand  = Brand.find_with_trackers(brand_id)
          client = brand.twitter_rest_client

          twitter_tracker        = brand.twitter_tracker
          direct_message_tracker = brand.twitter_direct_message_tracker

          mentions_timeline_options       = build_timeline_options(twitter_tracker)
          direct_message_timeline_options = build_timeline_options(direct_message_tracker)

          direct_messages = client.direct_messages_received(direct_message_timeline_options)
          tweets          = client.mentions_timeline(mentions_timeline_options)

          filter = Filter.new(brand, direct_messages.concat(tweets))
          filter.out_multiple_requests!
          filter.out_users_already_responded_to!

          respond_to_messages(filter.grouped_responses, client)

          TimelineHelper.update_tracker!(twitter_tracker, tweets)
          TimelineHelper.update_tracker!(direct_message_tracker, direct_messages)
        end

        private

        # @param grouped_responses [Hash]
        # @param client            [Twitter::REST::Client]
        def respond_to_messages(grouped_responses, client)
          grouped_responses.each do |hashtag, twitter_responses|
            twitter_responses.each do |twitter_response|
              twitter_response.respond!(client)
            end
          end
        end

        # @param  [TwitterTracker|TwitterDirectMessageTracker]
        # @return [Hash]
        def build_timeline_options(timeline_tracker)
          options = {
            count:    TimelineHelper::API_TIMELINE_LIMIT,
            since_id: timeline_tracker.since_id
          }

          options.merge!(max_id: timeline_tracker.max_id) unless timeline_tracker.max_id.nil?

          options
        end
      end
    end
  end
end

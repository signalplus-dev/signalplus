module Responders
  module Twitter
    class Listener
      API_TIMELINE_LIMIT = 200
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
          brand  = get_brand(brand_id)
          client = brand.twitter_rest_client

          twitter_tracker        = brand.twitter_tracker                || TwitterTracker.create(brand_id: brand.id)
          direct_message_tracker = brand.twitter_direct_message_tracker || TwitterDirectMessageTracker.create(brand_id: brand.id)

          mentions_timeline_options       = build_timeline_options(twitter_tracker)
          direct_message_timeline_options = build_timeline_options(direct_message_tracker)

          direct_messages = client.direct_messages_received(direct_message_timeline_options)
          tweets          = client.mentions_timeline(mentions_timeline_options)

          filter = Filter.new(brand, direct_messages.concat(tweets))
          filter.out_multiple_requests!
          filter.out_users_already_responded_to!

          respond_to_messages(filter.grouped_responses, client)

          update_message_tracker(tweets, twitter_tracker)
          update_message_tracker(direct_messages, direct_message_tracker)
        end

        private

        # @param grouped_responses [Hash]
        # @param client            [Twitter::REST::Client]
        def respond_to_messages(grouped_responses, client)
          grouped_responses.each do |hashtag, twitter_responses|
            next if twitter_responses.empty?

            twitter_responses.each do |twitter_response|
              begin
                signal_response = get_signal_response(hashtag)
                tweet = respond_to_message(signal_response, twitter_response[:to], client)
                TwitterResponse.create!(twitter_response.merge(tweet_id: tweet.id))
              rescue StandardError => e
                # do some logging
              end
            end
          end
        end

        def respond_to_message(message_response, screen_name, client)
          text_response = create_text_response(message_response['text_response'], screen_name)

          if message_response['image'].is_a?(String)
            begin
              temp_image = TempImage.new(message_response['image'])
              file = File.open(temp_image.file.path)
              respond_with_text_and_image(text_response, file, temp_image, client)
            rescue Aws::S3::Errors::NoSuchKey
              respond_with_text(text_response, client)
            end
          else
            respond_with_text(text_response, client)
          end
        end

        # @return [String]
        def create_text_response(text_response, screen_name)
          # a "d" at the beginning of the message indicates the desire to direct message the user
          "d @#{screen_name} #{text_response}"
        end

        def respond_with_text(text_response, client)
          client.update(text_response)
        end

        def respond_with_text_and_image(text_response, file, temp_image, client)
          client.update_with_media(text_response, file)
        ensure
          file.close
          temp_image.file.close
          temp_image.file.unlink
        end

        def update_message_tracker(messages, message_tracker)
          tracker_updated_attributes = TimelineHelper.get_new_timeline_options(
            messages,
            message_tracker.since_id,
            message_tracker.last_recorded_tweet_id,
            API_TIMELINE_LIMIT
          )

          message_tracker.assign_attributes(tracker_updated_attributes)
          message_tracker.save!
        end

        # @return [String]
        def get_signal_response(hashtag)
          HASHTAGS_TO_LISTEN_TO[hashtag]
        end

        # @return [Brand]
        def get_brand(brand_id)
          Brand
            .includes(:twitter_tracker, :twitter_direct_message_tracker)
            .where(id: brand_id)
            .first
        end

        # @param  [TwitterTracker|TwitterDirectMessageTracker]
        # @return [Hash]
        def build_timeline_options(timeline_tracker)
          options = {
            count:    API_TIMELINE_LIMIT,
            since_id: timeline_tracker.since_id
          }

          options.merge!(max_id: timeline_tracker.max_id) unless timeline_tracker.max_id.nil?

          options
        end
      end
    end
  end
end

class TwitterListener
  API_TIMELINE_LIMIT = 200
  HASHTAGS_TO_LISTEN_TO       = {
    'somehashtag' => {
      'text_response' => 'Hey, :screen_name check out this puppy!',
      'image'         => 'puppy_cuteness.gif',
    },
    'somehashtagwithoutimage' => {
      'text_response' => 'Hey, :screen_name check out this text response!',
    },
  }

  class << self
    def process_user_messages(user_id)
      twitter_tracker        = TwitterTracker.first_or_create
      direct_message_tracker = TwitterDirectMessageTracker.first_or_create

      mentions_timeline_options = {
        count:    API_TIMELINE_LIMIT,
        since_id: twitter_tracker.since_id
      }

      unless twitter_tracker.max_id.nil?
        mentions_timeline_options.merge!(max_id: twitter_tracker.max_id)
      end

      direct_message_timeline_options = {
        count:    API_TIMELINE_LIMIT,
        since_id: direct_message_tracker.since_id
      }

      unless direct_message_tracker.max_id.nil?
        direct_message_timeline_options.merge!(max_id: direct_message_tracker.max_id)
      end

      direct_messages = user_context_client.direct_messages_received(direct_message_timeline_options)
      tweets          = user_context_client.mentions_timeline(mentions_timeline_options)

      messages_to_respond_to = get_messages_to_respond_to(tweets)
      respond_to_messages(messages_to_respond_to)

      update_message_tracker(tweets, twitter_tracker)
      update_message_tracker(direct_messages, direct_message_tracker)
    end

    private

    def app_only_client
      @app_only_client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = 'pgPblG8uT6IG6jTwVOxxTF0jZ'
        config.consumer_secret     = 'zsfQgM7oXBSQ8hAemSTpocsXw36fX22ewUeRamOMb5yd8FysE7'
      end
    end

    def user_context_client
      @user_context_client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = 'pgPblG8uT6IG6jTwVOxxTF0jZ'
        config.consumer_secret     = 'zsfQgM7oXBSQ8hAemSTpocsXw36fX22ewUeRamOMb5yd8FysE7'
        config.access_token        = '4188300501-qkN5y8OYiiQJV93EXkQhDOuBsjx98PtwYj8WuGi'
        config.access_token_secret = 'FQLaKTW8ITdfQWbRW8eAcci1OZX1bfSG9sCFce1rSJppx'
      end
    end

    # @return [Array<Twitter::Tweet>]
    def get_messages_to_respond_to(messages)
      messages.select do |message|
        if message.hashtags.empty?
          false
        else
          message.hashtags.any? do |hashtag_obj|
            HASHTAGS_TO_LISTEN_TO.keys.include?(hashtag_obj.attrs[:text].downcase)
          end
        end
      end
    end

    def respond_to_messages(messages)
      # A key-value store of hashtags mapped to an array of user names to respond to.
      # Should be filtered out for any users that have already been responded to for that particular
      # hashtag for that day.
      grouped_by_hashtag            = {}
      # Keep track of what users are already going to be responded to with regards to a given hashtag
      users_responded_to_by_hashtag = {}
      messages.each do |message|
        message.hashtags.each do |hashtag_obj|
          case_insensitive_hashtag = hashtag_obj.attrs[:text].downcase
          message_response = HASHTAGS_TO_LISTEN_TO[case_insensitive_hashtag]

          unless message_response.nil?
            grouped_by_hashtag[case_insensitive_hashtag]            ||= []
            users_responded_to_by_hashtag[case_insensitive_hashtag] ||= Set.new

            original_size = users_responded_to_by_hashtag[case_insensitive_hashtag].size

            if message.is_a?(Twitter::Tweet)
              user = message.user
              response_type = 'Tweet'
            else
              user = message.sender
              response_type = 'DirectMessage'
            end

            users_responded_to_by_hashtag[case_insensitive_hashtag] << user.screen_name

            if users_responded_to_by_hashtag[case_insensitive_hashtag].size > original_size
              grouped_by_hashtag[case_insensitive_hashtag] << {
                screen_name:   user.screen_name,
                response_id:   message.id,
                response_type: response_type,
              }
            end
          end
        end
      end

      current_date = Date.current
      from         = user_context_client.user.screen_name
      grouped_by_hashtag.each do |hashtag, message_info|
        screen_names = message_info.map { |t| t[:screen_name] }
        users_already_responded_to =  TwitterResponse
                                        .where(date: current_date)
                                        .where(from: from)
                                        .where(hashtag: hashtag)
                                        .where(to: screen_names)
                                        .pluck(:to)

        messages_to_respond_to = message_info.reject { |t| users_already_responded_to.include?(t[:screen_name]) }

        if messages_to_respond_to.any?
          TwitterResponse.mass_insert_twitter_responses(current_date, from, hashtag, messages_to_respond_to)

          # Respond to the individual messages
          messages_to_respond_to.each do |message_info|
            message_response = HASHTAGS_TO_LISTEN_TO[hashtag]
            respond_to_message(message_response, message_info[:screen_name])
          end
        end
      end
    end

    def respond_to_message(message_response, screen_name)
      text_response = create_text_response(message_response['text_response'], screen_name)

      if message_response['image'].is_a?(String)
        begin
          temp_image = TempImage.new(message_response['image'])
          file = File.open(temp_image.file.path)
          respond_with_text_and_image(text_response, file, temp_image)
        rescue Aws::S3::Errors::NoSuchKey
          respond_with_text(text_response)
        end
      else
        respond_with_text(text_response)
      end
    end

    # @return [String]
    def create_text_response(text_response, screen_name)
      text_response.gsub(':screen_name', "@#{screen_name}")
    end

    def respond_with_text(text_response)
      user_context_client.update(text_response)
    end

    def respond_with_text_and_image(text_response, file, temp_image)
      user_context_client.update_with_media(text_response, file)
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
  end
end

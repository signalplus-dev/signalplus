class TwitterListener
  API_MENTIONS_TIMELINE_LIMIT = 200
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
    def process_user_tweets(user_id)
      twitter_tracker = TwitterTracker.first

      mentions_timeline_options = {
        count:    API_MENTIONS_TIMELINE_LIMIT,
        since_id: twitter_tracker.since_id
      }

      unless twitter_tracker.max_id.nil?
        mentions_timeline_options.merge!(max_id: twitter_tracker.max_id)
      end

      tweets = user_context_client.mentions_timeline(mentions_timeline_options)

      tweets_to_respond_to = get_tweets_to_respond_to(tweets)
      respond_to_tweets(tweets_to_respond_to)

      since_id,
      max_id,
      last_recorded_tweet_id = TwitterTracker.get_new_mentions_timeline_options(
        tweets,
        twitter_tracker.since_id,
        twitter_tracker.last_recorded_tweet_id
      )

      twitter_tracker.since_id               = since_id
      twitter_tracker.max_id                 = max_id
      twitter_tracker.last_recorded_tweet_id = last_recorded_tweet_id
      twitter_tracker.save!
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
        config.access_token        = '4188300501-EAM4fOgPouPeyAWHweRVJaE5Zf28DbtMGAGHXte'
        config.access_token_secret = 'ET7IdNID7UsV1YtkorS6qDMmAE7I3NyAisELKzwLJNuOR'
      end
    end

    # @return [Array<Twitter::Tweet>]
    def get_tweets_to_respond_to(tweets)
      tweets.select do |tweet|
        if tweet.hashtags.empty?
          false
        else
          tweet.hashtags.any? do |hashtag_obj|
            HASHTAGS_TO_LISTEN_TO.keys.include?(hashtag_obj.attrs[:text].downcase)
          end
        end
      end
    end

    def respond_to_tweets(tweets)
      # A key-value store of hashtags mapped to an array of user names to respond to.
      # Should be filtered out for any users that have already been responded to for that particular
      # hashtag for that day.
      grouped_by_hashtag = {}
      tweets.each do |tweet|
        tweet.hashtags.each do |hashtag_obj|
          case_insensitive_hashtag = hashtag_obj.attrs[:text].downcase
          twitter_response = HASHTAGS_TO_LISTEN_TO[case_insensitive_hashtag]

          unless twitter_response.nil?
            grouped_by_hashtag[case_insensitive_hashtag] ||= []
            grouped_by_hashtag[case_insensitive_hashtag] << {
              screen_name: tweet.user.screen_name,
              tweet_id:    tweet.id
            }
          end
        end
      end

      current_date = Date.current
      from         = user_context_client.user.screen_name
      grouped_by_hashtag.each do |hashtag, tweet_info|
        screen_names = tweet_info.map { |t| t[:screen_name] }
        users_already_responded_to =  TwitterResponse
                                        .where(date: current_date)
                                        .where(from: from)
                                        .where(hashtag: hashtag)
                                        .where(to: screen_names)
                                        .pluck(:to)

        tweets_to_respond_to = tweet_info.reject { |t| users_already_responded_to.include?(t[:screen_name]) }

        if tweets_to_respond_to.any?
          TwitterResponse.mass_insert_twitter_responses(current_date, from, hashtag, tweets_to_respond_to)

          # Respond to the individual tweets
          tweets_to_respond_to.each do |tweet_info|
            tweet_response = HASHTAGS_TO_LISTEN_TO[hashtag]
            respond_to_tweet(tweet_response, tweet_info[:screen_name])
          end
        end
      end
    end

    def respond_to_tweet(tweet_response, screen_name)
      text_response = create_text_response(tweet_response['text_response'], screen_name)

      if tweet_response['image'].is_a?(String)
        begin
          temp_image = TempImage.new(tweet_response['image'])
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
  end
end

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

      tweets = client.mentions_timeline(mentions_timeline_options)

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

    def client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = 'pgPblG8uT6IG6jTwVOxxTF0jZ'
        config.consumer_secret     = 'zsfQgM7oXBSQ8hAemSTpocsXw36fX22ewUeRamOMb5yd8FysE7'
        config.access_token        = '4188300501-EAM4fOgPouPeyAWHweRVJaE5Zf28DbtMGAGHXte'
        config.access_token_secret = 'ET7IdNID7UsV1YtkorS6qDMmAE7I3NyAisELKzwLJNuOR'
      end
    end

    def get_tweets_to_respond_to(tweets)
      tweets.select do |tweet|
        if tweet.hashtags.empty?
          false
        else
          tweet.hashtags.any? do |hashtag|
            HASHTAGS_TO_LISTEN_TO.keys.include?(hashtag.attrs[:text])
          end
        end
      end
    end

    def respond_to_tweets(tweets)
      tweets.each do |tweet|
        tweet.hashtags.each do |hashtag|
          tweet_response = HASHTAGS_TO_LISTEN_TO[hashtag.attrs[:text]]

          unless tweet_response.nil?
            text_response = create_text_response(
              tweet_response['text_response'],
              tweet.user.screen_name
            )

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
        end
      end
    end

    def create_text_response(text_response, screen_name)
      text_response.gsub(':screen_name', "@#{screen_name}")
    end

    def respond_with_text(text_response)
      client.update(text_response)
    end

    def respond_with_text_and_image(text_response, file, temp_image)
      client.update_with_media(text_response, file)
    ensure
      file.close
      temp_image.file.close
      temp_image.file.unlink
    end
  end
end

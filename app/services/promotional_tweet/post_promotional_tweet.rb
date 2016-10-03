class PostPromotionalTweet

  attr_reader :message, :encoded_image, :listen_signal_id, :brand, :client

  def initialize(tweet_params, brand)
    @message           = tweet_params[:message]
    @encoded_image     = tweet_params[:encoded_image]
    @listen_signal_id  = tweet_params[:listen_signal_id]
    @brand             = brand
    @client            = brand.twitter_rest_client
  end

  def send!
    tweet = post_promo_tweet
    tweet_id = tweet.id

    if tweet_id.present?
      PromotionalTweet.create_posted_tweet!(listen_signal_id, message, tweet_id)
    else
      raise StandardError.new('Failed to post to twitter')
    end
  end

  private

  def post_promo_tweet
    if encoded_image.present?
      post_tweet_with_image
    else
      post_tweet
    end
  end

  def post_tweet
    client.update(message)
  end

  def post_tweet_with_image
    temp_file = Tempfile.new('tmp_img.png', encoding: decoded_image.encoding)
    temp_file.write(decoded_image)
    client.update_with_media(message, temp_image)
  end

  def decoded_image
    Base64.decode64(encoded_image)
  end
end

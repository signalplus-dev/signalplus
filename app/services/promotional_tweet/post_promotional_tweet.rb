class PostPromotionalTweet

  def initialize(promotional_tweet, image, brand)
    @message = promotional_tweet.message
    @image   = image
    @brand   = brand
    @client  = brand.twitter_rest_client
  end

  def send!
    @tweet = post_promo_tweet

    if @tweet.present?
      @promotional_tweet.update_attribute!(:tweet_url, @tweet.id)
      tweet_url
    else
      raise StandardError.new('Failed to post to twitter')
    end
  end

  private

  def post_promo_tweet
    if @image.present?
      post_tweet_with_image
    else
      post_tweet
    end
  end

  def post_tweet
    @client.update(@message)
  end

  def post_tweet_with_image
    @client.update_with_media(@message, @image)
  end

  def tweet_url
    @brand.tweet_url(@tweet)
  end
end

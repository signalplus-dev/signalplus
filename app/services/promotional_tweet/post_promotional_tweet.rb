class PostPromotionalTweet

  attr_reader :image, :message, :image, :brand, :client

  def initialize(promotional_tweet, image, brand)
    @promotional_tweet = promotional_tweet
    @message           = promotional_tweet.message
    @image             = image
    @brand             = brand
    @client            = brand.twitter_rest_client
  end

  def send!
    tweet = post_promo_tweet
    tweet_id = tweet.id

    if tweet_id.present?
      promotional_tweet.update_posted_tweet_id(tweet_id)
    else
      raise StandardError.new('Failed to post to twitter')
    end
  end

  private

  def post_promo_tweet
    if image.present?
      post_tweet_with_image
    else
      post_tweet
    end
  end

  def post_tweet
    client.update(message)
  end

  def post_tweet_with_image
    client.update_with_media(message, image)
  end

end

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
    binding.pry

    temp_file = Tempfile.new('tmp_img.png', encoding: decoded_image.encoding)
    temp_file.write(decoded_image)
    file = File.open(temp_file.path)
    client.update_with_media(message, file)
  ensure
    file.close
    temp_file.close
  end

  def decoded_image
    Base64.decode64(encoded_image)
  end

  def create_temp_image
    temp_image = Tempfile.new('tmp_img.png', encoding: decoded_image.encoding)
    temp_image.write(decoded_image)
  end
end

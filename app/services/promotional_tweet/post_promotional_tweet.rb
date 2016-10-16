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
    create_temp_file
    file = File.open(temp_file_name)
    client.update_with_media(message, file)
  ensure
    file.close
    delete_temp_file
  end

  def decoded_image
    @decoded_image ||= Base64.decode64(encoded_image)
  end

  def temp_file_name
    @temp_file_name ||= "#{folder_location}/temp_file_#{SecureRandom.hex}#{file_extension}"
  end

  def create_temp_file
    # Make the temp directory to store the image file
    folder_path.mkdir unless folder_path.exist?

    File.open(temp_file_name, "wb") do |f|
      f.write(decoded_image)
    end
  end

  def delete_temp_file
    File.delete(temp_file_name)
  end

  def folder_path
    @folder_path ||= Pathname.new(folder_location)
  end

  def folder_location
    "#{Rails.root}/tmp/images"
  end

  def file_extension
    return '' unless image

    ".#{image.format.downcase}"
  end

  def image
    @image ||= Magick::Image.from_blob(decoded_image).first
  end
end

# Handles async Promotional Tweet create and processing workflow
class CreatePromotionalTweet

  attr_reader :current_user, :params, :promotional_tweet

  # @param params [Hash]
  def initialize(params)
    @params = params
    build
  end

  # @return [Boolean] PromotionalTweet saved
  def enqueue_process
    saved = @promotional_tweet.save
    if saved
      queue_process
    end
    saved
  end

  private

  def build
    @promotional_tweet = PromotionalTweet.new(@params)
  end

  def queue_process
    promo_tweet = {
      id: @promotional_tweet.id,
      image: URI.parse(@promotional_tweet.direct_upload_url),
      status: 'processed'
    }

    ProcessPromotionalTweetImagesWorker.perform_async(promo_tweet)
  end
end

class ProcessPromotionalTweetImagesWorker
  include Sidekiq::Worker

  def perform(promo_tweet)
    promotional_tweet = PromotionalTweet.find(promo_tweet[:id])

    promotional_tweet.image = promo_tweet.image
    promotional_tweet.status = promo_tweet.status
    promotional_tweet.save!
  end
end

class ProcessPromotionalTweetWorker
  include Sidekiq::Worker

  def perform(promotional_tweet)
    promotional_tweet.image = URI.parse(promotional_tweet.direct_upload_url)
    promotional_tweet.status = "processed"
    promotional_tweet.save!
  end
end

class ProcessPromotionalTweetWorker
  include Sidekiq::Worker

  def perform(promotional_image)
    promotional_image.upload = URI.parse(promotional_image.direct_upload_url)
    promotional_image.status = "processed"
    promotional_image.save!
  end
end

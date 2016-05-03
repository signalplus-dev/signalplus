class TwitterResponseWorker
  include Sidekiq::Worker

  sidekiq_options :retry => true

  def perform(brand_id, response_as_json, update_tracker)
    brand = Brand.find_with_trackers(brand_id)
    response = Responders::Twitter::Response.build(brand: brand, as_json: response_as_json)
    response.respond!

    if update_tracker
      timeline_tracker = response.tweet? ? brand.tweet_tracker : brand.twitter_dm_tracker
      TimelineHelper.update_tracker!(timeline_tracker, response)
    end
  end
end

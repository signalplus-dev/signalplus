class TwitterResponseWorker
  include TwitterHelper
  include Sidekiq::Worker

  sidekiq_options :retry => true, unique: :until_and_while_executing

  def perform(brand_id, response_as_json)
    brand = Brand.find_with_trackers(brand_id)

    if brand.turn_off_twitter_streaming?
      brand.turn_off_twitter_streaming!
    else
      Time.use_zone(brand.tz) do
        reply = Responders::Twitter::Reply.build(brand: brand, as_json: response_as_json)
        reply.respond!
      end
    end
  rescue Twitter::Error => e
    # Twitter Errors should trigger a retry. Check also if we are being rate limited
    rate_limit_check(e, brand)
    raise
  rescue StandardError => e
    # Log the error
    Rollbar.error(e, brand_id: brand_id, response: response_as_json)
  end
end

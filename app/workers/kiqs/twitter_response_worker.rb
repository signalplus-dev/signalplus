class TwitterResponseWorker
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
  end
end

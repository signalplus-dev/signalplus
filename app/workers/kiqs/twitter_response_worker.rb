class TwitterResponseWorker
  include Sidekiq::Worker

  sidekiq_options :retry => true, unique: :until_and_while_executing

  def perform(brand_id, response_as_json)
    brand = Brand.find_with_trackers(brand_id)
    response = Responders::Twitter::Response.build(brand: brand, as_json: response_as_json)
    response.respond!
  end
end

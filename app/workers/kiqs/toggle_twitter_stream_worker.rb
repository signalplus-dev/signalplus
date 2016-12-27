class ToggleTwitterStreamWorker
  include Sidekiq::Worker

  sidekiq_options :retry => true, unique: :until_and_while_executing

  def perform(brand_id)
    brand = Brand.find(brand_id)

    if brand.turn_on_twitter_streaming?
      BackgroundRake.call_rake(:twitter_stream, brand_id: brand.id)
    else
      brand.turn_off_everything!
    end
  rescue ActiveRecord::RecordNotFound
    # Do nothing; good for local development if resetting the DB often
    raise unless Rails.env.development?
  end
end

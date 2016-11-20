class CheckBrandResponseCountWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false, unique: :until_and_while_executing

  def perform(brand_id)
    brand = Brand.find(brand_id)
    Time.use_zone(brand.tz) do
      if brand.surpassed_trial_message_count?
        brand.subscription.end_trial!
      end
    end
  end
end

class TwitterCronJob
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options :retry => false

  recurrence backfill: false do
    hourly.minute_of_hour(*(0...60).to_a)
  end

  def perform(last_occurrence, current_occurrence)
    sleep Time.at(current_occurrence).min

    Brand.select(:id).find_each do |b|
      TwitterListener.process_brand_messages(b.id)
    end
  end
end

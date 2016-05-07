class TwitterCronJob
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options :retry => false

  recurrence backfill: false do
    hourly.minute_of_hour(*(0...60).step(2).to_a)
  end

  def perform(last_occurrence, current_occurrence)
    Brand.twitter_cron_job_query.find_each do |brand|
      # Kiq off listener async with delay
      Responders::Twitter::Listener.delay.process_messages(brand.id)
    end
  end
end

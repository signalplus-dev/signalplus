class TwitterCronJob
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options :retry => false

  recurrence backfill: false do
    hourly.minute_of_hour(*(0...60).to_a)
  end

  def perform(last_occurrence, current_occurrence)
    sleep Time.at(current_occurrence).min
    TwitterListener.process_user_messages(1)
  end
end

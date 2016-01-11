require 'pry'

class TwitterCronJob
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options :retry => false

  recurrence backfill: false do
    secondly(61)
  end

  def perform(last_occurrence, current_occurrence)
    TwitterListener.process_user_tweets(1)
  end
end

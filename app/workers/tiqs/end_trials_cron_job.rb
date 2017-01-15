class EndTrialsCronJob
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options :retry => false

  recurrence backfill: false do
    minutely(10)
  end

  def perform(last_occurrence, current_occurrence)
    Subscription.passed_trial.find_each do |subscription|
      subscription.end_trial!
    end
  end
end

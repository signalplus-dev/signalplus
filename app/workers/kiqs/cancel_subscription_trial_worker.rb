class CancelSubscriptionTrialWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false, unique: :until_and_while_executing

  def perform(subscription_id)
    Subscription.find(subscription_id).end_trial!
  end
end

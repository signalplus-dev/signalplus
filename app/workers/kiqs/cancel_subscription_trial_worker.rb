class CancelSubscriptionTrialWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false, unique: :until_and_while_executing

  def perform(subscription_id)
    subscription = Subscription.find(subscription_id)

    unless subscription.canceled?
      subscription.end_trial!
    end
  end
end

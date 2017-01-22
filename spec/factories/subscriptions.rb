# == Schema Information
#
# Table name: subscriptions
#
#  id                     :integer          not null, primary key
#  brand_id               :integer
#  subscription_plan_id   :integer
#  provider               :string
#  token                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  canceled_at            :datetime
#  trial_end              :datetime
#  trial                  :boolean          default(TRUE)
#  deleted_at             :datetime
#  lock_version           :integer          default(0)
#  will_be_deactivated_at :datetime
#

FactoryGirl.define do
  factory :subscription do
    brand
    provider 'Stripe'
    token { "sub_#{SecureRandom.base64[0...14]}" }
    subscription_plan { SubscriptionPlan.basic }
    trial_end { Subscription::NUMBER_OF_DAYS_OF_TRIAL.days.from_now }
    trial true

    trait :not_on_trial do
      trial false
    end

    trait :passed_trial do
      trial_end { 1.minute.ago }
    end
  end
end

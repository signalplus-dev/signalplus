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
#  trial_end              :datetime         not null
#  trial                  :boolean          default(TRUE)
#  deleted_at             :datetime
#  lock_version           :integer          default(0)
#  will_be_deactivated_at :datetime
#

FactoryGirl.define do
  factory :subscription do
    provider 'Stripe'
    token 'sub_8q6Cc93nR3NR59'
    association :subscription_plan, factory: :subscription_plan
    trial_end Subscription::NUMBER_OF_DAYS_OF_TRIAL.days.from_now
  end
end

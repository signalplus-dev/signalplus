# == Schema Information
#
# Table name: subscriptions
#
#  id                   :integer          not null, primary key
#  brand_id             :integer
#  subscription_plan_id :integer
#  provider             :string
#  token                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  canceled_at          :datetime
#  trial_end            :datetime         not null
#

FactoryGirl.define do
  factory :subscription do
    provider 'Stripe'
    token 'sub_8q6Cc93nR3NR59'
    association :subscription_plan, factory: :subscription_plan
  end
end

FactoryGirl.define do
  factory :subscription do
    provider 'Stripe'
    token 'sub_8q6Cc93nR3NR59'
    association :subscription_plan, factory: :subscription_plan
  end
end

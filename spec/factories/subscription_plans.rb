FactoryGirl.define do
  factory :subscription_plan do
    provider 'Stripe'
    provider_id 'basic'
    amount 2900
    name 'Basic'
    currency 'usd'
    number_of_messages 5000
  end
end

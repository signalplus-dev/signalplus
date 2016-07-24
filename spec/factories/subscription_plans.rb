# == Schema Information
#
# Table name: subscription_plans
#
#  id                 :integer          not null, primary key
#  amount             :integer
#  name               :string
#  number_of_messages :integer
#  currency           :string
#  provider           :string
#  provider_id        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :subscription_plan do
    provider 'Stripe'
    provider_id 'basic'
    amount 2900
    name 'Basic'
    currency 'usd'
    number_of_messages 5000

    trait :advanced do
      name 'Advanced'
      provider_id 'advanced'
      number_of_messages 15000
    end
  end
end

# == Schema Information
#
# Table name: responses
#
#  id                :integer          not null, primary key
#  message           :text
#  response_type     :string
#  response_group_id :integer
#  expiration_date   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  priority          :integer
#

FactoryGirl.define do
  factory :response do
    message 'check out this zebra!'
    response_type 'direct_message'
    expiration_date 2.days.from_now
    response_group

    trait :default do
      message 'this is the default message'
      response_type 'default'
      priority 1
    end

    trait :expired do
      message 'this is the expired message'
      response_type 'expired'
      priority 2
    end

    trait :first do
      message 'this is the first response'
      response_type 'first'
      priority 1
    end

    trait :repeat do
      message 'this is the repeat response'
      response_type 'repeat'
      priority 2
    end
  end
end

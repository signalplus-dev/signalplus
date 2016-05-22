# == Schema Information
#
# Table name: listen_signals
#
#  id              :integer          not null, primary key
#  brand_id        :integer
#  identity_id     :integer
#  name            :text
#  expiration_date :datetime
#  active          :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :listen_signal do
    brand
    identity
    name 'somehashtag'
    expiration_date 2.days.from_now
    active true

    trait :expired do
      expiration_date 2.days.ago
    end

    trait :with_response_group do
      after(:build) do |listen_signal|
        listen_signal.response_group ||= FactoryGirl.build(:response_group, listen_signal: listen_signal)
      end
    end
  end
end

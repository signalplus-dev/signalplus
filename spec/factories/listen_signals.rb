# == Schema Information
#
# Table name: listen_signals
#
#  id              :integer          not null, primary key
#  brand_id        :integer
#  identity_id     :integer
#  name            :text
#  active          :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  signal_type     :string
#  expiration_date :datetime
#  deleted_at      :datetime
#

FactoryGirl.define do
  factory :listen_signal do
    brand
    identity
    name 'somehashtag'
    expiration_date 2.days.from_now
    active true
    signal_type ListenSignal::Types::OFFERS

    trait :expired do
      expiration_date 2.days.ago
    end

    trait :with_response_group do
      after(:build) do |listen_signal|
        listen_signal.response_group ||= FactoryGirl.build(:response_group, listen_signal: listen_signal)
      end
    end

    trait :offer do
      signal_type ListenSignal::Types::OFFERS
    end

    trait :today do
      signal_type ListenSignal::Types::TODAY
    end

    trait :contest do
      signal_type ListenSignal::Types::CONTEST
    end

    trait :reminder do
      signal_type ListenSignal::Types::REMINDER
    end
  end
end

# == Schema Information
#
# Table name: response_groups
#
#  id               :integer          not null, primary key
#  listen_signal_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryGirl.define do
  factory :response_group do
    factory :response_group_with_responses do
      transient do
        response_count 3
      end

      after(:create) do |response_group, evaluator|
        evaluator.response_count.times do |n|
          response_group.responses << create(:response, priority: n)
        end
        response_group.responses << create(:response, :default)
        response_group.responses << create(:response, :expired)
      end
    end
  end
end

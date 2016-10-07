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
#

class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :subscription_plan_id, :number_of_messages, :monthly_response_count
end

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
#  description        :string           default("")
#

class SubscriptionPlanSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :amount, :currency_symbol, :number_of_messages
end

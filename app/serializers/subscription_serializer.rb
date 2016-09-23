class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :subscription_plan_id, :number_of_messages
end

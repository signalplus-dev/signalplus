class BrandSerializer < ActiveModel::Serializer
  attributes :id, :name

  # Associations
  attributes :subscription

  def subscription
    object.subscription.as_json(only: [:id, :subscription_plan_id])
  end
end

class BrandSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_name, :profile_image_url

  # Associations
  attributes :subscription

  def subscription
    object.subscription.as_json(only: [
      :id,
      :subscription_plan_id,
    ], methods: [
      :number_of_messages,
      :name,
    ])
  end
end

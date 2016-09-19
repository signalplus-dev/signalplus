# == Schema Information
#
# Table name: brands
#
#  id                  :integer          not null, primary key
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  streaming_tweet_pid :integer
#  polling_tweets      :boolean          default(FALSE)
#

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

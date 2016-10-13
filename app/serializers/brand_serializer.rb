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
  belongs_to :subscription

  # Normalized Association Attributes
  attribute :twitter_admin_email do
    object.twitter_admin.try(:email)
  end
end

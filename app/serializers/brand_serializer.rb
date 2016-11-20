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
#  tz                  :string
#

class BrandSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_name, :profile_image_url, :tz

  # Associations
  belongs_to :subscription
end

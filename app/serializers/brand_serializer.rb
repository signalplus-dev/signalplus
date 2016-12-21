# == Schema Information
#
# Table name: brands
#
#  id                    :integer          not null, primary key
#  name                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  streaming_tweet_pid   :integer
#  polling_tweets        :boolean          default(FALSE)
#  tz                    :string           default("America/New_York"), not null
#  deleted_at            :datetime
#  accepted_terms_of_use :boolean          default(FALSE)
#

class BrandSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :user_name,
             :profile_image_url,
             :tz,
             :accepted_terms_of_use

  # Associations
  belongs_to :subscription
end

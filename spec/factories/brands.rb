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
#  tz                  :string           default("America/New_York"), not null
#

FactoryGirl.define do
  factory :brand do
    name 'Nike'
  end
end

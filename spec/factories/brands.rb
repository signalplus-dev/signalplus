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

FactoryGirl.define do
  factory :brand do
    name 'Nike'
  end

  factory :user do
    brand
    email 'test@signal.me'
    name "signal"
    password "123456789"
    confirmed_at Time.current
  end

  factory :identity do
    brand
    user
    provider 'twitter'
    uid 'random text'
    encrypted_token Identity.encrypt('token_key')
    encrypted_secret Identity.encrypt('shared_key')
  end
end

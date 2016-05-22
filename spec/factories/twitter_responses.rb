# == Schema Information
#
# Table name: twitter_responses
#
#  id                 :integer          not null, primary key
#  to                 :string           not null
#  date               :date             not null
#  reply_tweet_id     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  request_tweet_id   :integer          default(0), not null
#  brand_id           :integer
#  reply_tweet_type   :string
#  request_tweet_type :string
#  listen_signal_id   :integer
#  response_id        :integer
#

FactoryGirl.define do
  factory :twitter_response do
    to 'randomtwitterhandle'
    date Date.current
    request_tweet_id 123456789
    request_tweet_type 'Tweet'

    trait :replied do
      reply_tweet_id 123456790
      reply_tweet_type 'DirectMessage'
    end
  end
end

# == Schema Information
#
# Table name: promotional_tweets
#
#  id               :integer          not null, primary key
#  message          :text
#  listen_signal_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  tweet_id         :integer
#  deleted_at       :datetime
#

FactoryGirl.define do
  factory :promotional_tweet do
    message 'this is a promotional tweet!'
    listen_signal 

    trait :posted do 
      tweet_id '23242342'
    end
  end
end

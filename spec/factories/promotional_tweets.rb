FactoryGirl.define do
  factory :promotional_tweet do
    message 'this is a promotional tweet!'
    listen_signal 

    trait :posted do 
      tweet_url 'tweet url'
      posted_at Time.now
    end
  end
end

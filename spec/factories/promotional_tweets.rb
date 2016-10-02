FactoryGirl.define do
  factory :promotional_tweet do
    message 'this is a promotional tweet!'
    listen_signal 

    trait :posted do 
      tweet_id '23242342'
    end
  end
end

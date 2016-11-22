FactoryGirl.define do
  factory :user do
    brand
    email 'test@signal.me'
    name "signal"
    password "123456789"
    confirmed_at Time.current

    trait :temp_email do
      email "#{User::TEMP_EMAIL_PREFIX}.com"
    end

    trait :unsubscribed do
      email_subscription false
    end

    trait :subscribed do
      email_subscription true
    end
  end
end

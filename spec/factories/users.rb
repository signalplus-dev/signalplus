# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  brand_id               :integer
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  tokens                 :json
#  email_subscription     :boolean          default(FALSE)
#  deleted_at             :datetime
#

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

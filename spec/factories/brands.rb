FactoryGirl.define do
  factory :brand do
    name 'Nike'

    # after_create do |brand|
    #   brand.identities << FactoryGirl.create(:identity)
    #   brand.users << FactoryGirl.create(:user)
    # end
  end

  factory :user do
    email "testing@signal.com"
    name "signal"
    password "123456789"
    brand
  end

  factory :identity do
    brand
    provider 'twitter'
    uid 'random text'
    encrypted_token Identity.encrypt('token_key')
    encrypted_secret Identity.encrypt('shared_key')
  end
end

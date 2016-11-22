FactoryGirl.define do
  factory :identity do
    brand
    user
    provider 'twitter'
    uid 'random text'
    encrypted_token Identity.encrypt('token_key')
    encrypted_secret Identity.encrypt('shared_key')
  end
end

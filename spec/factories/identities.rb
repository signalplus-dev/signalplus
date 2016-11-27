# == Schema Information
#
# Table name: identities
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  brand_id          :integer
#  provider          :string
#  uid               :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  encrypted_token   :string
#  encrypted_secret  :string
#  user_name         :string
#  profile_image_url :string
#  deleted_at        :datetime
#

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

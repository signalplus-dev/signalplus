# == Schema Information
#
# Table name: identities
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Brand < ActiveRecord::Base


  has_many :users
  has_many :identities


  def get_token_info(provider)
    encrypted_token  = identities.where(provider: provider).first.encrypted_token
    encrypted_secret = identities.where(provider: provider).first.encrypted_secret

    token      = Identity.decrypt(encrypted_token)
    secret_key = Identity.decrypt(encrypted_secret)

    return token, secret_key
  end
end

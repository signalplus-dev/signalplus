# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Brand < ActiveRecord::Base


  has_many :users
  has_many :identities


  def get_token_info(provider)
    encrypted_token  = identities.where(provider: provider).first.encrypted_token
    encrypted_secret = identities.where(provider: provider).first.encrypted_secret

    keys = {
      provider:   provider,
      token:      Identity.decrypt(encrypted_token),
      secret: Identity.decrypt(encrypted_secret)
    }
  end
end

class Brand < ActiveRecord::Base


  has_many :users
  has_many :identities


  def post_message(provider)
    token      = identities.where(provider: provider).first.encrypted_token
    secret_key = identities.where(provider: provider).first.encrypted_token
  end
end

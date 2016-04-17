class AddEncryptedKeystoIdentites < ActiveRecord::Migration
  def change
    add_column :identities, :encrypted_token, :string
    add_column :identities, :encrypted_secret, :string
  end
end

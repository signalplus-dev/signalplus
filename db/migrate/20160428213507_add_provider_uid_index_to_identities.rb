class AddProviderUidIndexToIdentities < ActiveRecord::Migration
  def change
    add_index :identities, [:provider, :uid], :unique => true
  end
end

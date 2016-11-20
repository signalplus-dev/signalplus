class AddLockVersionToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :lock_version, :integer
  end
end

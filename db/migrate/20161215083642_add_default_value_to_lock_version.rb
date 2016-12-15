class AddDefaultValueToLockVersion < ActiveRecord::Migration[5.0]
  def up
    remove_column :subscriptions, :lock_version
    add_column :subscriptions, :lock_version, :integer, default: 0
  end

  def down
    change_column :subscriptions, :lock_version, :integer
  end
end

class AddUniqueIndexToBrandIdOfSubscriptions < ActiveRecord::Migration
  def change
    remove_index :subscriptions, :brand_id
    add_index :subscriptions, :brand_id, unique: true
  end
end

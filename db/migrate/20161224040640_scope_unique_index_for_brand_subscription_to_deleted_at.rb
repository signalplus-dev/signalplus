class ScopeUniqueIndexForBrandSubscriptionToDeletedAt < ActiveRecord::Migration[5.0]
  def up
    remove_index :subscriptions, :brand_id
    add_index    :subscriptions, [:brand_id, :deleted_at], unique: true
  end

  def down
    remove_index :subscriptions, [:brand_id, :deleted_at]
    add_index    :subscriptions, :brand_id, unique: true
  end
end

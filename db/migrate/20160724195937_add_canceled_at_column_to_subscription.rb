class AddCanceledAtColumnToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :canceled_at, :datetime
    add_index :subscriptions, :canceled_at
  end
end

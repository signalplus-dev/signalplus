class AddWillBeCanceledAtColumnToSubscription < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :will_be_deactivated_at, :datetime
  end
end

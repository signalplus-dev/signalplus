class AddEmailSubscriptionToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_subscription, :boolean
  end
end

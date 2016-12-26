class AddIndexToSubscriptionStripeToken < ActiveRecord::Migration[5.0]
  def change
    add_index :subscriptions, :token, unique: true
  end
end

class AddIndexOnTrialForSubscription < ActiveRecord::Migration[5.0]
  def change
    add_index :subscriptions, :trial
  end
end

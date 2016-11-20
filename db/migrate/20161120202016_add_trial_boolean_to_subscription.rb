class AddTrialBooleanToSubscription < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :trial, :boolean, default: true
  end
end

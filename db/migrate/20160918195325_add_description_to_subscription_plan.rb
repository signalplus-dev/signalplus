class AddDescriptionToSubscriptionPlan < ActiveRecord::Migration
  def change
    add_column :subscription_plans, :description, :string, default: ''
  end
end

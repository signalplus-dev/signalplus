class CreateSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :subscription_plans do |t|
      t.integer :amount
      t.string :name
      t.integer :number_of_messages
      t.string :currency
      t.string :provider
      t.string :provider_id

      t.timestamps null: false
    end
  end
end

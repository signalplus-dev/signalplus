class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :brand, index: true
      t.references :subscription_plan, index: true
      t.string :provider
      t.string :token

      t.timestamps null: false
    end
  end
end

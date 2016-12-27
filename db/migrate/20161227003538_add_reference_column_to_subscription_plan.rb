class AddReferenceColumnToSubscriptionPlan < ActiveRecord::Migration[5.0]
  def up
    add_column :subscription_plans, :reference, :string, null: false, default: ''
    change_column_default :subscription_plans, :reference, nil
    ActiveRecord::Base.connection.execute(%q{
      UPDATE
        "subscription_plans"
      SET
        "reference" = lower("name");
    })
  end

  def down
    remove_column :subscription_plans, :reference
  end
end

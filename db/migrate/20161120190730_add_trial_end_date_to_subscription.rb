class AddTrialEndDateToSubscription < ActiveRecord::Migration[5.0]
  def up
    add_column :subscriptions, :trial_end, :datetime
    ActiveRecord::Base.connection.execute(%q{
      UPDATE "subscriptions"
      SET trial_end = created_at + INTERVAL '14 days';
    })
    change_column :subscriptions, :trial_end, :datetime, null: false
  end

  def down
    remove_column :subscriptions, :trial_end
  end
end

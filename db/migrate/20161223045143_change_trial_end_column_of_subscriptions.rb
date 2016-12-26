class ChangeTrialEndColumnOfSubscriptions < ActiveRecord::Migration[5.0]
  def up
    change_column :subscriptions, :trial_end, :datetime, null: true
  end

  def down
    change_column :subscriptions, :trial_end, :datetime, null: false
  end
end

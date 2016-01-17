class CreateTwitterDirectMessageTrackers < ActiveRecord::Migration
  def change
    create_table :twitter_direct_message_trackers do |t|
      t.timestamps null: false
    end

    add_column :twitter_direct_message_trackers, :last_recorded_tweet_id, :bigint, default: 1
    add_column :twitter_direct_message_trackers, :since_id,               :bigint, default: 1
    add_column :twitter_direct_message_trackers, :max_id,                 :bigint
  end

  def down
    drop_table :twitter_direct_message_trackers
  end
end

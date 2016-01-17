class CreateTwitterTrackers < ActiveRecord::Migration
  def up
    create_table :twitter_trackers do |t|
      t.timestamps null: false
    end

    add_column :twitter_trackers, :last_recorded_tweet_id, :bigint, default: 1
    add_column :twitter_trackers, :since_id,               :bigint, default: 1
    add_column :twitter_trackers, :max_id,                 :bigint
  end

  def down
    drop_table :twitter_trackers
  end
end

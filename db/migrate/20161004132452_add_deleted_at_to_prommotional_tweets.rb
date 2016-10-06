class AddDeletedAtToPrommotionalTweets < ActiveRecord::Migration
  def change
    add_column :promotional_tweets, :deleted_at, :datetime
    add_index :promotional_tweets, :deleted_at
    add_column :response_groups, :deleted_at, :datetime
    add_index :response_groups, :deleted_at
    add_column :responses, :deleted_at, :datetime
    add_index :responses, :deleted_at
  end
end

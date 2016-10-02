class AddTweetIdTimestamp < ActiveRecord::Migration
  def change
    remove_column :promotional_tweets, :tweet_url, :string, default: nil
    add_column :promotional_tweets, :tweet_id, :string
    add_column :promotional_tweets, :posted_at, :datetime
  end
end

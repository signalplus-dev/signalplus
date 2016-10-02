class AddTweetIdTimestamp < ActiveRecord::Migration
  def change
    remove_column :promotional_tweets, :tweet_url, :string, default: nil
    add_column :promotional_tweets, :tweet_id, :bigint
  end
end

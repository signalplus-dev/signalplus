class AddStreamingAndPollingColumns < ActiveRecord::Migration
  def change
    add_column :brands, :streaming_tweet_pid, :bigint,  default: nil
    add_column :brands, :polling_tweets,      :boolean, default: false
    add_index  :brands, :polling_tweets
    add_index  :brands, :streaming_tweet_pid
  end
end

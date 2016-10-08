class AddUniqueCompoundIndexForTwitterResponse < ActiveRecord::Migration
  def up
    add_index :twitter_responses, [
      :request_tweet_id,
      :listen_signal_id,
      ], unique: true,
      name: 'index_unique_request_tweet_id'
  end

  def down
    remove_index :twitter_responses, name: 'index_unique_request_tweet_id'
  end
end

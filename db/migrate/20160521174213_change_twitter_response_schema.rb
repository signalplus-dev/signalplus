class ChangeTwitterResponseSchema < ActiveRecord::Migration
  def change
    rename_column :twitter_responses, :tweet_id,    :reply_tweet_id
    rename_column :twitter_responses, :response_id, :request_tweet_id

    add_column :twitter_responses, :reply_tweet_type,   :string
    add_column :twitter_responses, :request_tweet_type, :string
    add_column :twitter_responses, :listen_signal_id,   :int
    add_column :twitter_responses, :response_id,        :int

    remove_column :twitter_responses, :response_type, :string
    remove_column :twitter_responses, :hashtag,       :string

    add_index :twitter_responses, :listen_signal_id
    add_index :twitter_responses, :response_id
  end
end

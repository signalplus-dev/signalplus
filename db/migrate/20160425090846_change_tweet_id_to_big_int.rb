class ChangeTweetIdToBigInt < ActiveRecord::Migration
  def change
    change_column :twitter_responses, :tweet_id, :bigint
  end
end

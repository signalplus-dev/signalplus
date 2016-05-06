class AddStreamingBooleanToBrand < ActiveRecord::Migration
  def change
    add_column :brands, :streaming_tweets, :boolean, default: false
    add_column :brands, :polling_tweets,   :boolean, default: false
    add_index  :brands, :polling_tweets
  end
end

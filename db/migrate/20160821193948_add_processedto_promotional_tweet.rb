class AddProcessedtoPromotionalTweet < ActiveRecord::Migration
  def change
    add_column :promotional_tweets, :status, :boolean, default: false, null: false
    add_column :promotional_tweets, :direct_upload_url, :string, null: false
  end
end

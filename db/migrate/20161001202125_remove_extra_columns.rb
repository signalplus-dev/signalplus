class RemoveExtraColumns < ActiveRecord::Migration
  def change
    remove_column :promotional_tweets, :image_file_name
    remove_column :promotional_tweets, :image_content_type
    remove_column :promotional_tweets, :image_file_size
    remove_column :promotional_tweets, :image_updated_at
    remove_column :promotional_tweets, :direct_upload_url
    remove_column :promotional_tweets, :status
    add_column :promotional_tweets, :tweet_url, :string, default: nil
  end
end

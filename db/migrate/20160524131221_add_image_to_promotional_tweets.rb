class AddImageToPromotionalTweets < ActiveRecord::Migration
  def up
    add_attachment :promotional_tweets, :image
  end
end

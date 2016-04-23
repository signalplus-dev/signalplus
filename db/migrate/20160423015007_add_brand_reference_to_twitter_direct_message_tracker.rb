class AddBrandReferenceToTwitterDirectMessageTracker < ActiveRecord::Migration
  def change
    add_reference :twitter_direct_message_trackers, :brand, foreign_key: true
    add_index     :twitter_direct_message_trackers, :brand_id, unique: true
  end
end

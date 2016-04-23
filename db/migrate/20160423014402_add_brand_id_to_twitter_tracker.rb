class AddBrandIdToTwitterTracker < ActiveRecord::Migration
  def change
    add_reference :twitter_trackers, :brand, foreign_key: true
    add_index     :twitter_trackers, :brand_id, unique: true
  end
end

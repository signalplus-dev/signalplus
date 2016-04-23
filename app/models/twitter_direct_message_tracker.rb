# == Schema Information
#
# Table name: twitter_direct_message_trackers
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  last_recorded_tweet_id :integer          default(1)
#  since_id               :integer          default(1)
#  max_id                 :integer
#  brand_id               :integer
#

class TwitterDirectMessageTracker < ActiveRecord::Base
end

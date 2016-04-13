# == Schema Information
#
# Table name: twitter_trackers
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  last_recorded_tweet_id :integer          default(1)
#  since_id               :integer          default(1)
#  max_id                 :integer
#

class TwitterTracker < ActiveRecord::Base

end

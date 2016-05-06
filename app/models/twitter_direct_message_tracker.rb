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
  validate :last_recorded_tweet_id_increasing

  private

  def last_recorded_tweet_id_increasing
    if last_recorded_tweet_id_was > last_recorded_tweet_id
      errors.add(:last_recorded_tweet_id, 'cannot decrease')
    end
  end
end

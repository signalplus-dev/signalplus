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

class TwitterDirectMessageTracker < ApplicationRecord
  belongs_to :brand
  has_one    :related_tweet_tracker, through: :brand, source: :tweet_tracker

  validate :last_recorded_tweet_id_increasing

  after_update :check_if_can_turn_off_polling

  class << self
    def turn_off_polling(brand_id)
      Brand.find(brand_id).turn_off_twitter_polling!
    end
  end

  def caught_up?
    since_id == last_recorded_tweet_id && max_id.nil?
  end

  private

  def last_recorded_tweet_id_increasing
    if last_recorded_tweet_id_was > last_recorded_tweet_id
      errors.add(:last_recorded_tweet_id, 'cannot decrease')
    end
  end

  def should_turn_off_polling?
    caught_up? && related_tweet_tracker.caught_up? && brand.polling_tweets?
  end

  def check_if_can_turn_off_polling
    if should_turn_off_polling?
      self.class.delay.turn_off_polling(brand_id)
    end
  end
end

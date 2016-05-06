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
#  brand_id               :integer
#

class TwitterTracker < ActiveRecord::Base
  belongs_to :brand
  has_one    :related_dm_tracker, through: :brand, source: :twitter_dm_tracker

  validate :last_recorded_tweet_id_increasing

  after_update :check_if_can_turn_off_polling

  class << self
    def turn_off_polling(brand_id)
      Brand.find(brand_id).turn_off_polling!
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
    caught_up? && related_dm_tracker.caught_up?
  end

  def check_if_can_turn_off_polling
    if should_turn_off_polling?
      self.class.delay.turn_off_polling(brand.id)
    end
  end
end

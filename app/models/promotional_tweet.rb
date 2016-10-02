# == Schema Information
#
# Table name: promotional_tweets
#
#  id               :integer          not null, primary key
#  message          :text
#  listen_signal_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  tweet_id         :integer
#

class PromotionalTweet < ActiveRecord::Base
  belongs_to :listen_signal

  def update_posted_tweet_id(tweet_id)
    update_attributes!(tweet_id: tweet_id, posted_at: Time.now.getutc)
  end

  def tweet_url(tweet_id)
    listen_signal.brand.tweet_url(tweet_id)
  end
end

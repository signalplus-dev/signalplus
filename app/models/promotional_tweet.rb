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
  acts_as_paranoid
  belongs_to :listen_signal

  def self.create_posted_tweet!(listen_signal_id, message, tweet_id)
    create! do |p|
      p.listen_signal_id = listen_signal_id
      p.message = message
      p.tweet_id = tweet_id
    end
  end

  def tweet_url
    listen_signal.brand.tweet_url(tweet_id)
  end
end

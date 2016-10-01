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

end

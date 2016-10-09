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
#  deleted_at       :datetime
#

class PromotionalTweetSerializer < ActiveModel::Serializer
  attributes :id, :message, :listen_signal_id, :tweet_id, :tweet_url
end

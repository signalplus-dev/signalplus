# == Schema Information
#
# Table name: twitter_responses
#
#  id                 :integer          not null, primary key
#  to                 :string           not null
#  date               :date             not null
#  reply_tweet_id     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  request_tweet_id   :integer          default(0), not null
#  brand_id           :integer
#  reply_tweet_type   :string
#  request_tweet_type :string
#  listen_signal_id   :integer
#  response_id        :integer
#

class TwitterResponse < ActiveRecord::Base
  module ResponseType
    TWEET          = 'Tweet'
    DIRECT_MESSAGE = 'DirectMessage'
  end

  class << self
    def tweets
      where(response_type: ResponseType::TWEET)
    end

    def direct_messages
      where(response_type: ResponseType::DIRECT_MESSAGE)
    end
  end

  # @return [Hash] A hash containing all the relevant Arel data to create the insert statment for
  #                the unpersisted, dummy TwitterResponse object
  def arel_mass_insert_attributes_for_create
    arel_attributes_with_values_for_create(TwitterResponse.twitter_response_mass_insert_attributes)
  end
end

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

require 'rails_helper'

describe TwitterResponse do
  describe '.mass_insert_twitter_responses' do
    let(:args) do
      [
        Date.current,
        'signal',
        'deals',
        (1..4).map { |n| { screen_name: "user#{n}", response_id: n, response_type: 'Tweet' } }
      ]
    end

    it 'can mass insert twitter responses' do
      expect {
        described_class.mass_insert_twitter_responses(*args)
      }.to change { TwitterResponse.tweets.count }.from(0).to(4)
    end
  end
end

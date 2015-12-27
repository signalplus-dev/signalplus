require 'rails_helper'

describe TwitterResponse do
  describe '.mass_insert_twitter_responses' do
    let(:args) do
      [
        Date.current,
        'signal',
        'deals',
        (1..4).map { |n| { screen_name: "user#{n}", tweet_id: n } }
      ]
    end

    it 'can mass insert twitter responses' do
      expect {
        described_class.mass_insert_twitter_responses(*args)
      }.to change { TwitterResponse.count }.from(0).to(4)
    end
  end
end

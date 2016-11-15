# == Schema Information
#
# Table name: brands
#
#  id                  :integer          not null, primary key
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  streaming_tweet_pid :integer
#  polling_tweets      :boolean          default(FALSE)
#  tz                  :string
#

require 'rails_helper'

describe Brand do
  let(:user)     { create(:user) }
  let(:identity) { create(:identity) }
  let(:brand)    { build(:brand) }

  describe '.get_token_info' do
    it 'associates brand' do
    end
  end

  context 'callbacks' do
    describe '#create_trackers' do
      it 'calls on the callback on create' do
        expect(brand).to receive(:create_trackers)
        brand.save!
      end

      it 'does not call on the callback after it has already been created' do
        brand.save!
        expect(brand).to_not receive(:create_trackers)
        brand.name = 'Reebok'
        brand.save!
      end

      it 'automatically creates a twitter and dm tracker' do
        brand.save!
        expect(brand.tweet_tracker).to_not      be_nil
        expect(brand.twitter_dm_tracker).to_not be_nil
      end
    end
  end

  describe '#monthly_twitter_responses' do
    let(:response_group) { create(:default_group_responses) }
    let(:listen_signal)  { create(:listen_signal, response_group: response_group, brand: brand, identity: identity) }

    before do
      brand.save!
      create(:twitter_response, :replied, brand: brand, listen_signal: listen_signal, response: response_group.default_response)
    end

    context 'with no deleted signal' do
      it 'has one response' do
        expect(brand.monthly_twitter_responses.count).to eq(1)
      end
    end

    context 'with a deleted signal' do
      it 'still has one response' do
        listen_signal.destroy
        expect(brand.monthly_twitter_responses.count).to eq(1)
      end
    end
  end
end

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
end

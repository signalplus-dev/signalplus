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
#  tz                  :string           default("America/New_York"), not null
#

require 'rails_helper'

describe Brand do
  let(:user)     { create(:user) }
  let(:identity) { create(:identity) }
  let(:brand)    { build(:brand) }

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

  describe '#tz' do
    it 'only accepts valid time zones' do
      brand.tz = 'ljdlja'
      expect(brand).to be_invalid
      brand.tz = nil
      expect(brand).to be_invalid
      brand.tz = 3
      expect(brand).to be_invalid
      brand.tz = brand
      expect(brand).to be_invalid
      brand.tz = 'America/Chicago'
      expect(brand).to be_valid
    end

    it 'adds an error message' do
      brand.tz = 'ljdlja'
      brand.valid?
      expect(brand.errors.full_messages).to include('Tz is not valid')
    end
  end

  context 'soft deleting brand' do
    let(:brand)           { create(:brand) }
    let!(:subscription)   { create(:subscription) }
    let!(:response_group) { create(:default_group_responses) }
    let!(:listen_signal) { create(:listen_signal, :offer, response_group: response_group) }
    let!(:non_admin_user) { create(:user, email: 'nonadmin@signal.com', brand: brand) }

    context 'associated objects' do
      it 'soft deletes brand' do
        brand.destroy!
        expect(brand.deleted_at).not_to be_nil
      end

      it 'soft deletes brand listen signals' do
        brand.destroy!
        expect(listen_signal.reload.deleted_at).not_to be_nil
      end

      it 'soft deletes brand response group' do
        brand.destroy!
        expect(response_group.reload.deleted_at).not_to be_nil
      end

      it 'soft deletes brand subscription' do
        brand.destroy!
        expect(subscription.reload.deleted_at).not_to be_nil
      end

      it 'soft deletes brand users' do
        brand.destroy!
        # expect(brand.users.reload.deleted_at).not_to be_nil
        expect(non_admin_user.reload.deleted_at).not_to be_nil
      end
    end

    describe '#unsubscribe_users_from_newsletter' do
      let(:brand)              { create(:brand) }
      let!(:subscribed_user)   { create(:user, :subscribed, brand: brand) }
      let!(:unsubscribed_user) { create(:user, :unsubscribed, brand: brand, email: 'xxx@gmail.com') }

      it 'unsubscribes subscribed users' do
        brand.unsubscribe_users_from_newsletter
        expect(subscribed_user.reload.email_subscription).to be_falsey
        expect(subscribed_user.reload.email_subscription).to be_falsey
      end
    end
  end
end

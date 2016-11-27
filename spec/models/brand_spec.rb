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

  context 'with associated objects' do
    context 'soft delete' do
      let!(:user1)          { create(:user, email: 'random@email.com', brand: brand) }
      let!(:user2)          { create(:user, email: 'random2@email.com', brand: brand) }
      let!(:subscription)   { create(:subscription, brand: brand) }
      let!(:listen_signal)  { create(:listen_signal, :offer, brand: brand) }
      let!(:response_group) { create(:default_group_responses, listen_signal: listen_signal) }
      let!(:identity)       { create(:identity, uid: 'wtf', user: user1, brand: brand)}

      it 'soft deletes listen signals' do
        expect {
          brand.destroy
        }.to change {
          ListenSignal.deleted.count
        }.from(0).to(1)
      end

      it 'soft deletes response groups' do
        expect {
          brand.destroy
        }.to change {
          ResponseGroup.deleted.count
        }.from(0).to(1)
      end

      it 'soft deletes subscription' do
        expect {
          brand.destroy
        }.to change {
          Subscription.deleted.count
        }.from(0).to(1)
      end

      it 'soft deletes users' do
        expect {
          brand.destroy
        }.to change {
          User.deleted.count
        }.from(0).to(2)
      end

      it 'soft deletes identities' do
        expect {
          brand.destroy
        }.to change {
          Identity.deleted.count
        }.from(0).to(1)
      end

      context 'without subscription' do
        it 'does not raise error' do
          expect {
            brand.subscription = nil
            brand.save!
            brand.destroy
          }.to_not raise_error
        end
      end

      describe '#delete_account' do
        it 'soft deletes brand' do
          expect(brand).to receive(:unsubscribe_users_from_newsletter)
          expect(brand.subscription).to receive(:cancel_plan!)
          brand.delete_account
          expect(brand.deleted_at).to_not be_nil
        end
      end
    end
  end

  describe '#unsubscribe_users_from_newsletter' do
    let!(:subscribed_user)   { create(:user, :subscribed, brand: brand) }
    let!(:unsubscribed_user) { create(:user, :unsubscribed, brand: brand, email: 'xxx@gmail.com') }

    it 'unsubscribes subscribed users' do
      brand.unsubscribe_users_from_newsletter
      expect(subscribed_user.reload.email_subscription).to be_falsey
      expect(subscribed_user.reload.email_subscription).to be_falsey
    end
  end
end

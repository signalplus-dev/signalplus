# == Schema Information
#
# Table name: subscriptions
#
#  id                   :integer          not null, primary key
#  brand_id             :integer
#  subscription_plan_id :integer
#  provider             :string
#  token                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  canceled_at          :datetime
#  trial_end            :datetime         not null
#  trial                :boolean          default(TRUE)
#  lock_version         :integer
#

require 'rails_helper'
require 'shared/stripe'

describe Subscription do
  include_context 'stripe setup'

  describe '.subscribe' do
    it 'creates a payment handler' do
      expect {
        described_class.subscribe!(brand, basic_plan, stripe_token)
      }.to change {
        PaymentHandler.count
      }.from(0).to(1)
    end

    it 'creates a subscription' do
      expect {
        described_class.subscribe!(brand, basic_plan, stripe_token)
      }.to change {
        described_class.count
      }.from(0).to(1)
    end
  end

  context 'a brand already subscribed to a plan' do
    before do
      described_class.subscribe!(brand, basic_plan, stripe_token)
      allow(subscription).to receive(:stripe_subscription).and_return(stripe_subscription)
    end

    describe '#update_plan!' do
      let(:update_stripe_subscription!) do
        stripe_response = nil

        VCR.use_cassette('update_stripe_subscription') do
          subscription.stripe_subscription.plan = advanced_plan.provider_id
          stripe_response = subscription.stripe_subscription.save
        end

        stripe_response
      end

      before do
        allow(subscription).to receive(:update_stripe_subscription!).and_return(update_stripe_subscription!)
      end

      it 'changes the subscription_plan' do
        expect {
          subscription.update_plan!(advanced_plan)
        }.to change {
          subscription.subscription_plan
        }.from(basic_plan).to(advanced_plan)
      end

      it 'logs the changes' do
        with_versioning do
          expect {
            subscription.update_plan!(advanced_plan)
          }.to change {
            subscription.versions.count
          }.from(0).to(1)
        end
      end
    end

    describe '.end_trial!' do
      let(:end_stripe_trial_subscription!) do
        stripe_response = nil

        VCR.use_cassette('end_stripe_trial_subscription') do
          subscription.stripe_subscription.trial_end = 'now'
          stripe_response = subscription.stripe_subscription.save
        end

        stripe_response
      end

      before do
        allow(subscription).to receive(:end_stripe_trial_subscription!).and_return(end_stripe_trial_subscription!)
      end

      it 'ends the trial' do
        expect {
          subscription.end_trial!
        }.to change {
          subscription.reload.trial?
        }.from(true).to(false)
      end
    end

    describe '.cancel_plan!' do
      let(:cancel_stripe_subscription!) do
        stripe_response = nil

        VCR.use_cassette('cancel_stripe_subscription') do
          stripe_response = subscription.stripe_subscription.delete
        end

        stripe_response
      end

      before do
        allow(subscription).to receive(:cancel_stripe_subscription!).and_return(cancel_stripe_subscription!)
      end

      it 'cancels the subscription' do
        expect {
          subscription.cancel_plan!
        }.to change {
          subscription.canceled?
        }.from(false).to(true)
      end

      it 'logs the changes' do
        with_versioning do
          expect {
            subscription.cancel_plan!
          }.to change {
            subscription.versions.count
          }.from(0).to(1)
        end
      end
    end
  end
end

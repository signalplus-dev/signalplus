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
#

require 'rails_helper'

describe Subscription do
  let(:brand)         { create(:identity).brand }
  let(:basic_plan)    { create(:subscription_plan) }
  let(:advanced_plan) { create(:subscription_plan, :advanced) }
  let(:subscription)  { described_class.first }
  let(:stripe_subscription) do
    stripe_object = nil

    VCR.use_cassette('stripe_subscription') do
      stripe_object = subscription.stripe_subscription
    end

    stripe_object
  end

  let(:stripe_token) do
    token = nil
    VCR.use_cassette('stripe_token') do
      token = Stripe::Token.create(
        card: {
          number:    "4242424242424242",
          exp_month: 7,
          exp_year:  2021,
          cvc:       "314",
        },
      )
    end

    token.id
  end

  let!(:stripe_customer) do
    customer = nil
    VCR.use_cassette('stripe_customer') do
      customer = described_class.send(:create_customer!, brand, basic_plan, stripe_token)
    end

    customer
  end

  before do
    allow(described_class).to receive(:create_customer!).and_return(stripe_customer)
  end

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

    describe '#update!' do
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
          subscription.update!(advanced_plan)
        }.to change {
          subscription.subscription_plan
        }.from(basic_plan).to(advanced_plan)
      end
    end

    describe '.cancel!' do
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
          subscription.cancel!
        }.to change {
          subscription.canceled?
        }.from(false).to(true)
      end
    end
  end
end

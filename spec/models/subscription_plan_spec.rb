require 'rails_helper'

describe SubscriptionPlan do
  let(:brand)             { create(:identity).brand }
  let(:subscription_plan) { create(:subscription_plan) }

  let(:stripe_token) do
    token = nil
    VCR.use_cassette("stripe_token") do
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
    VCR.use_cassette("stripe_customer") do
      customer = SubscriptionPlan.send(:create_customer!, brand, subscription_plan, stripe_token)
    end

    customer
  end

  before do
    allow(SubscriptionPlan).to receive(:create_customer!).and_return(stripe_customer)
  end

  describe '.subscribe' do
    it 'creates a payment handler' do
      expect {
        described_class.subscribe!(brand, subscription_plan, stripe_token)
      }.to change {
        PaymentHandler.count
      }.from(0).to(1)
    end

    it 'creates a subscription' do
      expect {
        described_class.subscribe!(brand, subscription_plan, stripe_token)
      }.to change {
        Subscription.count
      }.from(0).to(1)
    end
  end
end

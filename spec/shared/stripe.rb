require 'rails_helper'

shared_context 'stripe setup' do
  let(:identity)      { create(:identity) }
  let(:brand)         { identity.brand }
  let(:user)          { identity.user }
  let(:basic_plan)    { create(:subscription_plan) }
  let(:advanced_plan) { create(:subscription_plan, :advanced) }
  let(:subscription)  { Subscription.first }
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
    trial_end = 14.days.from_now.to_i
    VCR.use_cassette('stripe_customer') do
      customer = Subscription.send(:create_customer!, basic_plan, user.email, stripe_token, trial_end)
    end

    customer
  end

  before do
    allow(Subscription).to receive(:create_customer!).and_return(stripe_customer)
  end

  let(:new_plan) { basic_plan }
  let(:resubscribed_stripe_subscription) do
    stripe_response = nil
    Subscription.send(:create_payment_handler!, brand, stripe_customer)

    VCR.use_cassette('create_stripe_subscription') do
      stripe_response = Subscription.send(
        :create_stripe_subscription!,
        stripe_customer.id,
        new_plan.provider_id
      )
    end

    stripe_response
  end
end

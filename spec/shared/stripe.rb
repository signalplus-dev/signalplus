require 'rails_helper'

def create_stripe_plans
  SubscriptionPlan.all.each do |sp|
    stripe_helper.create_plan(
      id:       sp.provider_id,
      amount:   sp.amount,
      interval: 'month',
      name:     sp.name,
      currency: sp.currency,
    )
  end
end

shared_context 'stripe mock helper' do
  let(:stripe_helper) { StripeMock.create_test_helper }
end

shared_context 'stripe mock' do
  include_context 'stripe mock helper'

  before { StripeMock.start }
  after  { StripeMock.stop }
end

shared_context 'setup models' do
  let(:identity)      { create(:identity) }
  let(:brand)         { identity.brand }
  let(:user)          { identity.user }
  let(:email)         { user.email }
  let(:basic_plan)    { SubscriptionPlan.basic }
  let(:advanced_plan) { SubscriptionPlan.advanced }
  let(:premium_plan)  { SubscriptionPlan.premium }
  let(:admin_plan)    { SubscriptionPlan.admin }
  let(:subscription)  { Subscription.first }
end

shared_context 'stripe setup' do
  include_context 'setup models'

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

  let(:update_stripe_subscription!) do
    stripe_response = nil

    VCR.use_cassette('update_stripe_subscription') do
      subscription.stripe_subscription.plan = advanced_plan.provider_id
      stripe_response = subscription.stripe_subscription.save
    end

    stripe_response
  end
end

shared_context 'brand already subscribed to plan' do
  before do
    Subscription.subscribe!(user.brand, basic_plan, user.email, stripe_token)
    allow_any_instance_of(Subscription)
      .to receive(:stripe_subscription).and_return(stripe_subscription)
    allow_any_instance_of(Subscription)
      .to receive(:update_stripe_subscription!).and_return(update_stripe_subscription!)
  end
end

shared_context 'upgrade plan' do
  include_context 'setup models'
  include_context 'stripe mock helper'

  let(:stripe_subscription) do
    stripe_response = nil

    VCR.use_cassette('stripe_subscription_2') do
      stripe_response = subscription.stripe_subscription
    end

    stripe_response
  end

  let(:stripe_token) do
    token = nil
    VCR.use_cassette('stripe_token_2') do
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
    VCR.use_cassette('stripe_customer_2') do
      customer = Subscription.send(:create_customer!, basic_plan, user.email, stripe_token, nil)
    end

    customer
  end

  before do
    allow(Subscription).to receive(:create_customer!).and_return(stripe_customer)
  end

  let(:upgrade_to_advanced) do
    stripe_response = nil

    VCR.use_cassette('upgrade_stripe_subscription') do
      allow(subscription).to receive(:trialing?).and_return(false)
      stripe_response = subscription.send(:update_stripe_subscription!, advanced_plan)
    end

    stripe_response
  end

  let(:last_100_events) do
    events = nil

    VCR.use_cassette('last_100_events') do
      events = Stripe::Event.list(limit: 100)
    end

    events
  end

  let(:last_invoice_created_event) do
    last_100_events.data.find do |event|
      event.data.object.try(:customer) == stripe_customer.id &&
      event.type == 'invoice.created'
    end
  end

  before do
    Subscription.subscribe!(user.brand, basic_plan, user.email, stripe_token)
    allow_any_instance_of(Subscription)
      .to receive(:stripe_subscription).and_return(stripe_subscription)
    allow_any_instance_of(Subscription)
      .to receive(:update_stripe_subscription!).and_return(upgrade_to_advanced)

    StripeWebhook::InvoiceHandler.new(last_invoice_created_event).created
  end
end

shared_context 'create stripe plans' do
  include_context 'stripe mock'

  before { create_stripe_plans }
end

shared_context 'stripe mock create subscription' do
  include_context 'create stripe plans'

  let(:brand)         { create(:brand) }
  let(:email)         { 'test@example.com'}
  let(:basic_plan)    { SubscriptionPlan.basic }
  let(:advanced_plan) { SubscriptionPlan.advanced }

  before do
    Subscription.subscribe!(brand, basic_plan, email, stripe_helper.generate_card_token)
  end
end

shared_context 'invoice created' do
  include_context 'stripe mock create subscription'

  let(:event) { StripeMock.mock_webhook_event('invoice.created') }

  before do
    allow_any_instance_of(StripeWebhook::InvoiceHandler)
      .to receive(:get_brand_id).and_return(brand.id)
    StripeWebhook::InvoiceHandler.new(event).created
  end
end

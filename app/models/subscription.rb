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

class Subscription < ActiveRecord::Base
  belongs_to :brand
  belongs_to :subscription_plan
  has_many :monthly_twitter_responses,
    -> { paid.for_this_month },
    through: :brand,
    source: :twitter_responses

  has_paper_trail only: [:subscription_plan_id, :canceled_at], on: [:update]

  class << self
    # Subscribes a brand to to a subscription plan. Handles error outside of this method
    #
    # @param brand             [Brand] A brand object
    # @param subscription_plan [SubscriptionPlan] A subscription plan object
    # @param stripe_token      [String] The Stripe token response necessary to create the Stripe
    #                                   Customer object and their Stripe subscription
    def subscribe!(brand, subscription_plan, stripe_token)
      customer = create_customer!(brand, subscription_plan, stripe_token)

      if customer
        create_payment_handler!(brand, customer)
        create_subscription!(brand, subscription_plan, customer)
      end
    end

    private

    def create_customer!(brand, subscription_plan, stripe_token)
      Stripe::Customer.create(
        source: stripe_token,
        plan:   subscription_plan.provider_id,
        email:  brand.twitter_admin.email,
      )
    end

    def create_payment_handler!(brand, customer)
      PaymentHandler.create!(
        brand_id: brand.id,
        provider: 'Stripe',
        token:    customer.id
      )
    end

    def create_subscription!(brand, subscription_plan, customer)
      create!(
        brand_id:             brand.id,
        subscription_plan_id: subscription_plan.id,
        provider:             'Stripe',
        token:                customer.subscriptions.first.id
      )
    end
  end

  # Updates the subscription's subscription plan
  #
  # @param subscription_plan [SubscriptionPlan] A subscription plan object
  def update!(subscription_plan)
    stripe_subscription.plan = subscription_plan.provider_id
    update_stripe_subscription!
    update(subscription_plan_id: subscription_plan.id)
  end

  # Cancels the subscription plan
  def cancel!
    cancel_stripe_subscription!
    update(canceled_at: Time.current)
  end

  # @return [Stripe::Subscription]
  def stripe_subscription
    @stripe_subscription ||= Stripe::Subscription.retrieve(token)
  end

  # @return [Boolean]
  def canceled?
    !canceled_at.nil?
  end

  # @return [String]
  def name
    subscription_plan.try(:name)
  end

  # @return [Fixnum]
  def number_of_messages
    subscription_plan.try(:number_of_messages)
  end

  # TODO - use Stripe webhooks to keep this up-to-date
  # @return [Boolean]
  def past_due?
    false
  end

  # TODO - use Stripe webhooks to keep this up-to-date
  # @return [Boolean]
  def unpaid?
    false
  end

  # @return [Boolean]
  def valid_and_paid_for?
    !canceled? && !past_due? && !unpaid?
  end

  def monthly_response_count
    monthly_twitter_responses.count
  end

  private

  # Used to stub out in tests for mocking of the Stripe API response
  def update_stripe_subscription!
    stripe_subscription.save
  end

  def cancel_stripe_subscription!
    stripe_subscription.delete
  end
end

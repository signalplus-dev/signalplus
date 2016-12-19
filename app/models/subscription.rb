# == Schema Information
#
# Table name: subscriptions
#
#  id                     :integer          not null, primary key
#  brand_id               :integer
#  subscription_plan_id   :integer
#  provider               :string
#  token                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  canceled_at            :datetime
#  trial_end              :datetime
#  trial                  :boolean          default(TRUE)
#  deleted_at             :datetime
#  lock_version           :integer          default(0)
#  will_be_deactivated_at :datetime
#

class Subscription < ApplicationRecord
  class InvalidPlanUpdate < StandardError; end
  class InvalidPlan < StandardError
    def initialize(message = 'That is an invalid plan.')
      super(message)
    end
  end

  acts_as_paranoid

  belongs_to :brand
  belongs_to :subscription_plan

  has_paper_trail only: [
    :subscription_plan_id,
    :canceled_at,
    :will_be_deactivated_at,
  ], on: [:update]

  NUMBER_OF_DAYS_OF_TRIAL = ENV['NUMBER_OF_DAYS_OF_TRIAL'].to_i
  MAX_NUMBER_OF_MESSAGES_FOR_TRIAL = ENV['MAX_NUMBER_OF_MESSAGES_FOR_TRIAL'].to_i

  after_commit :toggle_twitter_streamer

  class << self
    # Subscribes a brand to to a subscription plan. Handles error outside of this method
    #
    # @param brand             [Brand] A brand object
    # @param subscription_plan [SubscriptionPlan] A subscription plan object
    # @param email             [String] email of the customer
    # @param stripe_token      [String] The Stripe token response necessary to create the Stripe
    #                                   Customer object and their Stripe subscription
    def subscribe!(brand, subscription_plan, email, stripe_token)
      raise InvalidPlan if subscription_plan.admin?

      trial_end = NUMBER_OF_DAYS_OF_TRIAL.days.from_now
      customer = create_customer!(email, stripe_token)

      if customer
        create_payment_handler!(brand, customer)
        subscription = create_subscription!(brand, subscription_plan, trial_end)
        CancelSubscriptionTrialWorker.perform_at(trial_end, subscription.id)
        subscription
      end
    end

    # Resubscribes a brand to a subscription if their previous subscription was deactivated
    #
    # @param brand             [Brand] A brand object
    # @param subscription_plan [SubscriptionPlan] A subscription plan object
    # @return                  [Subscription]
    def resubscribe!(brand, subscription_plan)
      stripe_subscription = create_stripe_subscription!(
        brand.stripe_customer_token,
        subscription_plan.provider_id
      )

      create_subscription!(brand, subscription_plan, nil, stripe_subscription.id)
    end

    # Used when resubscribing a user to a subscription
    #
    # @param customer  [String]
    # @param plan      [String]
    # @return          [Stripe::Subscription]
    def create_stripe_subscription!(customer, plan)
      Stripe::Subscription.create(
        customer:             customer,
        plan:                 plan,
        billing_cycle_anchor: 1.month.from_now.beginning_of_month.to_i,
      )
    end

    # @return [ActiveRecord::Relation]
    def passed_trial
      where(trial: true).where('trial_end < ?', Time.current)
    end

    private

    # Creates the Stripe customer and subscribes them to a trial subscription
    #
    # @param email             [String]
    # @param stripe_token      [String]
    # @return                  [Stripe::Customer]
    def create_customer!(email, stripe_token)
      Stripe::Customer.create(email:  email, source: stripe_token)
    end

    def create_payment_handler!(brand, customer)
      PaymentHandler.create!(
        brand_id: brand.id,
        provider: 'Stripe',
        token:    customer.id,
      )
    end

    # Creates the Subscription within our DB
    #
    # @param brand                  [Brand]
    # @param subscription_plan      [SubscriptionPlan]
    # @param trial_end              [ActiveSupport::TimeWithZone]
    # @param stripe_subscription_id [String]
    # @return                       [Subscription]
    def create_subscription!(brand, subscription_plan, trial_end = nil, stripe_subscription_id = nil)
      create!(
        brand_id:             brand.id,
        subscription_plan_id: subscription_plan.id,
        provider:             'Stripe',
        token:                stripe_subscription_id,
        trial_end:            trial_end,
        trial:                !!trial_end,
      )
    end
  end

  ###### Helper methods

  # @return [Stripe::Subscription]
  def stripe_subscription
    @stripe_subscription ||= Stripe::Subscription.retrieve(token)
  end

  # @return [String]
  def name
    subscription_plan.try(:name)
  end

  # @return [Fixnum]
  def number_of_messages
    subscription_plan.try(:number_of_messages)
  end

  # @return [ActiveRecord::Relation<TwitterResponse>]
  def monthly_twitter_responses
    brand.monthly_twitter_responses
  end

  # @return [Fixnum]
  def monthly_response_count
    monthly_twitter_responses.count
  end

  ###### Action/Dangerous methods

  # Updates the subscription's subscription plan
  #
  # @param new_plan [SubscriptionPlan] A subscription plan object
  # @return         [Subscription]
  def update_plan!(new_plan)
    raise InvalidPlan if new_plan.admin?

    check_if_can_change_plan_to(new_plan)
    if deactivated?
      resubscribe_and_destroy!(new_plan)
    else
      old_plan = subscription_plan

      # Make the updates
      update_stripe_subscription!(new_plan) unless trialing?
      update!(
        subscription_plan_id: new_plan.id,
        canceled_at: nil,
        will_be_deactivated_at: nil,
      )

      # When upgrading, we need to charge for an adjustment and remove
      # any proration. When downgrading we let stripe do their proration.
      if upgrading?(old_plan, new_plan) && !trialing?
        kickoff_invoice_adjustment_worker(old_plan, new_plan)
      end

      UserMailer.plan_change(brand)
      self
    end
  rescue Stripe::InvalidRequestError => e
    raise unless e.http_status == 404
    # TODO: need to test with a subscription that has been deactivated
    resubscribe_and_destroy!(subscription_plan)
  end

  # Cancels the subscription plan
  def cancel_plan!
    cancel_stripe_subscription! unless trialing?
    update!(
      canceled_at: Time.at(stripe_subscription.canceled_at),
      will_be_deactivated_at: Time.at(stripe_subscription.current_period_end),
    )
    UserMailer.cancel_plan(brand)
  end

  # Forcefully ends the trial subscription
  def end_trial!
    update_params = { trial: false }
    unless token?
      stripe_subscription = create_stripe_subscription!
      update_params[:token] = stripe_subscription.id
    end
    update!(update_params)
  end

  def create_stripe_subscription!
    Subscription.create_stripe_subscription!(
      brand.stripe_customer_token,
      subscription_plan.provider_id
    )
  end

  ###### Helper boolean methods

  # @return [Boolean]
  def canceled?
    !canceled_at.nil?
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
  def deactivated?
    will_be_deactivated_at? && will_be_deactivated_at <= Time.current
  end

  # @return [Boolean]
  def valid_and_paid_for?
    !canceled? && !past_due? && !unpaid?
  end

  # @return [Boolean]
  def trialing
    trial && trial_end > Time.current
  end
  alias_method :trialing?, :trialing

  # @return [Boolean]
  def at_plan_limit?
    brand.at_plan_limit?
  end

  # @return [Boolean]
  def admin
    subscription_plan.admin?
  end
  alias_method :admin?, :admin

  private

  # Used to stub out in tests for mocking of the Stripe API response
  # @param new_subscription_plan [SubscriptionPlan]
  def update_stripe_subscription!(new_subscription_plan)
    stripe_subscription.plan = new_subscription_plan.provider_id
    stripe_subscription.prorate = downgrading?(new_subscription_plan)
    stripe_subscription.billing_cycle_anchor = 'unchanged'
    stripe_subscription.save
  end

  def cancel_stripe_subscription!
    stripe_subscription.delete(at_period_end: true)
  end

  # @param subscription_plan [SubscriptionPlan]
  def resubscribe_and_destroy!(subscription_plan)
    Subscription.transaction do
      destroy!
      Subscription.resubscribe!(brand, subscription_plan)
    end
  end

  def check_if_can_change_plan_to(subscription_plan)
    if subscription_plan.number_of_messages < monthly_response_count
      raise InvalidPlanUpdate.new(
        'You cannot downgrade to that plan. You have surpassed the response limit.'
      )
    end
  end

  # @return [Boolean]
  def downgrading?(new_subscription_plan)
    new_subscription_plan.amount <= self.subscription_plan.amount
  end

  # @param old_plan [SubscriptionPlan]
  # @param new_plan [SubscriptionPlan]
  # @return         [Boolean]
  def upgrading?(old_plan, new_plan)
    new_plan.amount > old_plan.amount
  end

  # @param old_plan [SubscriptionPlan]
  # @param new_plan [SubscriptionPlan]
  def kickoff_invoice_adjustment_worker(old_plan, new_plan)
    InvoiceAdjustmentWorker.perform_in(1.minute, brand_id, old_plan.id, new_plan.id)
  end

  def toggle_twitter_streamer
    ToggleTwitterStreamWorker.perform_async(brand_id)
  end
end

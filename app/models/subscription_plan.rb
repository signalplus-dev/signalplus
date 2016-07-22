# == Schema Information
#
# Table name: subscription_plans
#
#  id                 :integer          not null, primary key
#  amount             :integer
#  name               :string
#  number_of_messages :integer
#  currency           :string
#  provider           :string
#  provider_id        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class SubscriptionPlan < ActiveRecord::Base
  class << self
    # TODO: add better error handling
    def subscribe!(brand, subscription_plan, stripe_token)
      customer = create_customer!(brand, subscription_plan, stripe_token)

      if customer
        create_payment_handler!(brand, customer)
        create_subscription!(brand, subscription_plan, customer)
      end
    end

    def update!

    end

    def cancel!
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
      Subscription.create!(
        brand_id:             brand.id,
        subscription_plan_id: subscription_plan.id,
        provider:             'Stripe',
        token:                customer.subscriptions.first.id
      )
    end
  end
end

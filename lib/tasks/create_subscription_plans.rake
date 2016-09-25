desc "Listens to a user's stream of mentions and direct messages"
task create_subscription_plans: :environment do
  subscription_plans = [
    {
      id:       'basic',
      amount:   2900,
      interval: 'month',
      name:     'Basic',
      description: 'Local Brands',
      currency: 'usd',
      number_of_messages: 5000,
    },
    {
      id:       'advanced',
      amount:   4900,
      interval: 'month',
      name:     'Advanced',
      description: 'National Brands',
      currency: 'usd',
      number_of_messages: 15000,
    },
    {
      id:       'premium',
      amount:   9900,
      interval: 'month',
      name:     'Premium',
      description: 'Global Brands',
      currency: 'usd',
      number_of_messages: 50000,
    },
  ]

  subscription_plans.each do |sp|
    begin
      Stripe::Plan.create(sp.slice(:id, :amount, :interval, :name, :currency))
    rescue Stripe::InvalidRequestError
    end

    SubscriptionPlan.find_or_create_by(
      sp.slice(:amount, :name, :number_of_messages, :currency, :description)
        .merge(provider: 'Stripe', provider_id: sp[:id])
    )
  end
end

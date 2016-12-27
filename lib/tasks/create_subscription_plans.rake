desc "Listens to a user's stream of mentions and direct messages"
task :create_subscription_plans, [:no_stripe] => [:environment] do |t, args|
  subscription_plans = [
    {
      id:                 'basic',
      amount:             2900,
      interval:           'month',
      name:               'Basic',
      reference:          'basic',
      description:        'Local Brands',
      currency:           'usd',
      number_of_messages: 5000,
    },
    {
      id:                 'advanced',
      amount:             4900,
      interval:           'month',
      name:               'Advanced',
      reference:          'advanced',
      description:        'National Brands',
      currency:           'usd',
      number_of_messages: 15000,
    },
    {
      id:                 'premium',
      amount:             9900,
      interval:           'month',
      name:               'Premium',
      reference:          'premium',
      description:        'Global Brands',
      currency:           'usd',
      number_of_messages: 50000,
    },
    {
      id:                 'admin',
      amount:             0,
      interval:           'month',
      name:               'Admin',
      reference:          'admin',
      description:        'N/A',
      currency:           'usd',
      number_of_messages: 1000000,
    },
  ]

  subscription_plans.each do |sp|
    unless args[:no_stripe]
      begin
        Stripe::Plan.create(sp.slice(:id, :amount, :interval, :name, :currency))
      rescue Stripe::InvalidRequestError
      end
    end

    SubscriptionPlan.find_or_create_by(
      sp.slice(:amount, :name, :number_of_messages, :currency, :description, :reference)
        .merge(provider: 'Stripe', provider_id: sp[:id])
    )
  end
end

Rake::Task["db:setup"].enhance do
  unless ENV['NO_SUBSCRIPTION_PLANS']
    Rake::Task[:create_subscription_plans].invoke
  end
end

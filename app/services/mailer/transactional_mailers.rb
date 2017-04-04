module TransactionalMailers
  def welcome(brand, email)
    self.new(
      self::Types::WELCOME,
      brand,
      [
        { name: 'BRAND_HASHTAG', content: brand.name },
        { name: 'SELECTED_PLAN_NAME', content: brand.subscription_plan.name }
      ],
      email
    )
  end

  def change_plan(brand)
    self.new(
      self::Types::CHANGE,
      brand,
      [
        { name: 'BRAND_HASHTAG', content: brand.name },
        { name: 'UPDATED_PLAN_NAME', content: brand.subscription_plan.name },
        { name: 'UPDATED_PLAN_START_DATE', content: brand.subscription_plan.updated_at.to_date }
      ]
    )
  end

  def cancel_plan(brand)
    self.new(
      self::Types::CANCEL,
      brand,
      [
        { name: 'BRAND_HASHTAG', content: brand.name },
        { name: 'CANCELED_PLAN_NAME', content: brand.subscription_plan.name },
        { name: 'CANCELED_PLAN_END_DATE', content: brand.subscription.will_be_deactivated_at.to_date }
      ]
    )
  end
end

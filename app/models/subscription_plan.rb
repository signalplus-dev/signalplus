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
#  description        :string           default("")
#

class SubscriptionPlan < ApplicationRecord
  CURRENCY_SYMBOL_MAPPING = {
    'usd' => '$',
  }

  module Type
    ALL = [
      BASIC    = 'basic',
      ADVANCED = 'advanced',
      PREMIUM  = 'premium',
    ]
  end

  class << self
    def all_plans
      @all_plans ||= all
    end
  end

  def currency_symbol
    CURRENCY_SYMBOL_MAPPING[currency]
  end

  # Metaprogramming to create helper methods
  # Singleton methods produced:
  #   .basic
  #   .advanced
  #   .premium
  #
  # Instance methods produced:
  #   #basic?
  #   #advanced?
  #   #premium?
  Type::ALL.each do |plan_name|
    # @return [SubscriptionPlan]
    define_singleton_method("#{plan_name}".to_sym) do
      all_plans.find(&"#{plan_name}?".to_sym)
    end

    # @return [Boolean]
    define_method("#{plan_name}?".to_sym) do
      name.to_s.downcase == __method__.to_s[0...-1]
    end
  end
end

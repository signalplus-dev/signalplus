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
end

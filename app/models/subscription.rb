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
#

class Subscription < ActiveRecord::Base
  belongs_to :brand
  belongs_to :subscription_plan
end

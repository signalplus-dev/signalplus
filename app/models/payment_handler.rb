# == Schema Information
#
# Table name: payment_handlers
#
#  id         :integer          not null, primary key
#  brand_id   :integer
#  provider   :string
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PaymentHandler < ApplicationRecord
  belongs_to :brand

  # @return [Stripe::Customer]
  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(token)
  end
end

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

class PaymentHandler < ActiveRecord::Base
  belongs_to :brand
end

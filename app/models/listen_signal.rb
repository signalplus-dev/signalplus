# == Schema Information
#
# Table name: listen_signals
#
#  id              :integer          not null, primary key
#  brand_id        :integer
#  identity_id     :integer
#  listen_to       :text
#  expiration_date :datetime
#  active          :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ListenSignal < ActiveRecord::Base
  belongs_to :brand
  has_one :response_group
  has_many :responses, through: :response_group

end

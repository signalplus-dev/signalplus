# == Schema Information
#
# Table name: listen_signals
#

class ListenSignal < ActiveRecord::Base
  belongs_to :brand
  has_one :response_group
  has_many :responses, through: :response_group

end

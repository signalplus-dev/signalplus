# == Schema Information
#
# Table name: responses
#
#  id                :integer          not null, primary key
#  message           :text
#  type              :string
#  response_group_id :integer
#  expiration_date   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Response < ActiveRecord::Base
  belongs_to :response_group

  def self.provider
    response_group.listen_signal.provider
  end

end

# == Schema Information
#
# Table name: responses
#
#  id                :integer          not null, primary key
#  message           :text
#  response_type     :string
#  response_group_id :integer
#  expiration_date   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  priority          :integer
#

class Response < ActiveRecord::Base
  belongs_to :response_group
  has_many :twitter_responses

  module Type
    DEFAULT = 'default'
    FIRST = 'first'
    REPEAT = 'repeat'
    EXPIRED = 'expired'
    FLOW    = 'flow'
  end

  def self.provider
    response_group.listen_signal.provider
  end

  # @return [Boolean]
  def default?
    response_type == Type::DEFAULT
  end

  # @return [Boolean]
  def expired?
    response_type == Type::EXPIRED
  end

  # below are dummy methods to ensure that tests for sending tweets/dms with images
  # still pass
  # @return [Boolean]
  def has_image?
    false
  end

  # @return [String]
  def image_name
    'puppy.gif'
  end
end

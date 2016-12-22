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
#  deleted_at        :datetime
#

class Response < ActiveRecord::Base
  validates :message, :response_type, :response_group_id, presence: true

  acts_as_paranoid

  belongs_to :response_group
  has_many :twitter_responses

  module Type
    DEFAULT = 'default'
    FIRST   = 'first'
    TIMED   = 'timed'
    FLOW    = 'flow'
    NOT_COUNTED = [
      REPEAT  = 'repeat',
      EXPIRED = 'expired',
    ]
  end

  DEFAULT_PRIORITY = {
    Type::DEFAULT => 0,
    Type::TIMED   => 0,
    Type::REPEAT  => 1000,
  }

  def self.provider
    response_group.listen_signal.provider
  end

  def self.create_response(message, type, response_group)
    Response.create! do |r|
      r.message = message
      r.response_type = type
      r.response_group = response_group
      r.priority = DEFAULT_PRIORITY[type]
    end
  end

  def self.create_timed_response(message, exp_date, response_group)
    Response.create do |r|
      r.message = message
      r.response_type = Type::TIMED
      r.response_group_id = response_group.id
      r.expiration_date = exp_date
      r.priority = DEFAULT_PRIORITY[Type::TIMED]
    end
  end

  def update_message(msg)
    update_attribute(:message, msg)
  end

  # @return [Boolean]
  def first?
    response_type == Type::FIRST
  end

  # @return [Boolean]
  def repeat?
    response_type == Type::REPEAT
  end

  # @return [Boolean]
  def default?
    response_type == Type::DEFAULT
  end

  # @return [Boolean]
  def timed?
    response_type == Type::TIMED
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

  # @return [Boolean]
  def paid?
    !Type::NOT_COUNTED.include?(response_type)
  end

  # @return [String]
  def image_name
    'puppy.gif'
  end
end

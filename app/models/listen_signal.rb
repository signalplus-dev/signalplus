# == Schema Information
#
# Table name: listen_signals
#
#  id              :integer          not null, primary key
#  brand_id        :integer
#  identity_id     :integer
#  name            :text
#  expiration_date :datetime
#  active          :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  signal_type     :string
#

class ListenSignal < ActiveRecord::Base
  validates :name, :brand_id, :identity_id, :expiration_date,
            :signal_type, presence: true


  belongs_to :brand
  belongs_to :identity
  has_one :response_group
  has_many :responses, through: :response_group
  has_many :promotional_tweets

  module Types
    OFFER    = :offer
    TODAY    = :today
    CONTEST  = :contest
    REMINDER = :reminder

    def self.values
      constants.map{ |t| const_get(t) }
    end
  end

  def self.active
    where(active: true)
  end

  def self.create_signal(brand, identity, name, signal_type, exp_date, active=true)
    ListenSignal.create do |s|
      s.brand_id = brand.id
      s.identity_id = identity.id
      s.name = name
      s.signal_type = signal_type
      s.expiration_date = exp_date
      s.active = active
    end
  end

  def first_response
    responses.where(response_type: Response::Type::FIRST).first
  end

  def repeat_response
    responses.where(response_type: Response::Type::REPEAT).first
  end

  def response(to)
    expired? ? response_group.expired_response : response_group.next_response(to)
  end

  def expired?
    expiration_date <= Time.current
  end

  def last_promotional_tweet
    @last_promotional_tweet ||= promotional_tweets.last
  end
end

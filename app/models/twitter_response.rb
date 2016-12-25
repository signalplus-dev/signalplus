# == Schema Information
#
# Table name: twitter_responses
#
#  id                 :integer          not null, primary key
#  to                 :string           not null
#  date               :date             not null
#  reply_tweet_id     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  request_tweet_id   :integer          default(0), not null
#  brand_id           :integer
#  reply_tweet_type   :string
#  request_tweet_type :string
#  listen_signal_id   :integer
#  response_id        :integer
#

class TwitterResponse < ActiveRecord::Base
  belongs_to :response, -> { with_deleted }
  belongs_to :listen_signal
  belongs_to :brand

  after_commit :increment_response_count!, if: :should_increment_response_count?
  after_commit :check_response_count, if: -> { !!brand && brand_in_trial? }

  module ResponseType
    TWEET          = 'Tweet'
    DIRECT_MESSAGE = 'DirectMessage'
  end

  class << self
    def tweets
      where(request_tweet_type: ResponseType::TWEET)
    end

    def direct_messages
      where(request_tweet_type: ResponseType::DIRECT_MESSAGE)
    end

    def paid
      joins('INNER JOIN responses ON "responses"."id" = "twitter_responses"."response_id"')
        .where.not(responses: { response_type: Response::Type::NOT_COUNTED })
    end

    def for_this_month
      where('EXTRACT(MONTH FROM "twitter_responses"."date") = ?', Date.current.month)
    end
  end

  # @return [Hash] A hash containing all the relevant Arel data to create the insert statment for
  #                the unpersisted, dummy TwitterResponse object
  def arel_mass_insert_attributes_for_create
    arel_attributes_with_values_for_create(TwitterResponse.twitter_response_mass_insert_attributes)
  end

  private

  def should_increment_response_count?
    response.paid?
  end

  def check_response_count
    CheckBrandResponseCountWorker.perform_async(brand_id)
  end

  def increment_response_count!
    brand.broadcast_monthly_response_count!
  end

  def brand_in_trial?
    brand.in_trial?
  end
end

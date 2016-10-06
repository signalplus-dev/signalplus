# == Schema Information
#
# Table name: response_groups
#
#  id               :integer          not null, primary key
#  listen_signal_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ResponseGroup < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :listen_signal
  has_many :responses, dependent: :destroy
  has_many :twitter_responses

  # @param [String] Who the response should be sent to
  # @return [Response]
  def next_response(to)
    last_response_priority = responses
                              .joins(:twitter_responses)
                              .where(twitter_responses: { to: to })
                              .where.not(twitter_responses: { reply_tweet_id: nil })
                              .where.not(response_type: Response::Type::EXPIRED)
                              .order(priority: :asc)
                              .limit(1)
                              .pluck(:priority)
                              .first

    last_response_priority ||= -1

    response = responses.find { |r| r.priority > last_response_priority }

    response || default_response
  end

  # @return [Response]
  def default_response
    responses.find(&:default?)
  end

  # @return [Response]
  def repeat_response
    responses.find(&:repeat?)
  end

  # @return [Response]
  def expired_response
    responses.find(&:expired?)
  end
end

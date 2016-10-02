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

class ListenSignalSerializer < ActiveModel::Serializer
  attributes :id, :name, :active, :expiration_date, :signal_type

  # Associations
  attributes :responses, :promotional_tweets

  def responses
    object.responses.as_json(only: [
      :id,
      :message,
      :response_type,
      :expiration_date,
      :priority,
    ])
  end

  def promotional_tweets
    object.promotional_tweets.as_json(only: [
      :id,
      :message,
      :listen_signal_id,
      :tweet_id,
    ])
  end
end

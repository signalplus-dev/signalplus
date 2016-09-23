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
  attributes :responses, :last_promotional_tweet

  def responses
    object.responses.as_json(only: [
      :id,
      :message,
      :response_type,
      :expiration_date,
      :priority,
    ])
  end

  def last_promotional_tweet
    object.last_promotional_tweet.as_json(only: [
      :id,
      :message,
      :direct_upload_url,
    ], methods: [
      :url,
    ])
  end
end

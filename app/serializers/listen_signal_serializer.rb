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

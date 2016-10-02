class PromotionalTweetSerializer < ActiveModel::Serializer
  attributes :id, :message, :listen_signal_id

  attributes :tweet_url

  def tweet_url
    object.tweet_url
  end
end

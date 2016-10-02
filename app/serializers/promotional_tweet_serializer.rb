class PromotionalTweetSerializer < ActiveModel::Serializer
  attributes :id, :message, :listen_signal_id, :tweet_url
end

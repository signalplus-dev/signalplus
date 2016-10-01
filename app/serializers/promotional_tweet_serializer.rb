class PromotionalTweetSerializer < ActiveModel::Serializer
  attributes :id, :message, :listen_signal_id

  attributes :methods

  def methods
    [:tweet_url]
  end
end

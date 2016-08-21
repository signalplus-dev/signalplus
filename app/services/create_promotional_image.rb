# Handles async Promotional Tweet create and processing workflow
class CreatePromotionalTweet

  attr_reader :current_user, :params, :promotional_tweet

  # @param params [Hash]
  def initialize(params)
    @params = params
    build
  end

  # @return [Boolean] Document saved
  def call
    saved = @promotional_tweet.save
    if saved
      queue_process
    end
    saved
  end

  private

  def build
    @promotional_tweet = PromotionalTweet.new(@params)
  end

  def queue_process
    ProcessPromotionalTweetWorker.perform_async(@document)
  end
end

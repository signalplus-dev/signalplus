class Api::V1::PromotionalTweetsController < Api::V1::BaseController
  before_action :get_brand, only: [:create]

  def index
    @promotional_tweets = PromotionalTweet.all
  end

  def create
    binding.pry
    image = params[:image]

    ActiveRecord::Base.transaction do
      @promotional_tweet = PromotionalTweet.create!(promo_tweet_params)
      post_tweet_service = PostPromotionalTweet.new(promotional_tweet, image, @brand)
      tweet_url = post_tweet_service.send!

      if tweet_url.empty? 
        raise ActiveRecord::Rollback
      end
    end

    render json: @promotional_tweet, each_serializer: PromotionalTweetSerializer
  end

  private

  def promo_tweet_params
    params.require(:promotional_tweet).permit(:signal_id, :message, :promotional_tweet_id)
  end
end



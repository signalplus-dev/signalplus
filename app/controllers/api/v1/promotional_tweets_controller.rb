class Api::V1::PromotionalTweetsController < ApplicationController

  def index
    @promotional_tweets = PromotionalTweet.all
  end

  def create
    @create_promotional_tweet_service = CreatePromotionalTweet.new(image_params)
    @promotional_tweet = @create_promotional_tweet_service.promotional_tweet
    if @create_promotional_tweet_service.call
      render :show, status: :created
    else
      render json: { errors: @promotional_tweet.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def image_params
    params.require(:promotional_tweet).permit(:listen_signal_id, :direct_upload_url, :image_content_type, :image_file_name, :image_file_size)
  end

  def tweet_params
    params.permit(:signal_id, :message)
  end
end

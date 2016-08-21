class Api::V1::PromotionalTweetsController < ApplicationController

  def index
    @promotional_tweets = PromotionalTweet.all
  end

  def create
    @create_promotional_tweet_service = CreatePromotionalTweet.new(document_params)
    @promotional_tweet = @create_promotional_tweet_service.promotional_tweet
    if @create_promotional_tweet_service.call
      render :show, status: :created
    else
      render json: { errors: @promotional_tweet.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def document_params
    params.require(:promotional_tweet).permit(:direct_upload_url, :upload_content_type, :upload_file_name, :upload_file_size)
  end

end

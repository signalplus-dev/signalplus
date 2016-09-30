class Api::V1::PromotionalTweetsController < Api::V1::BaseController

  def index
    @promotional_tweets = PromotionalTweet.all
  end

  def create
    @create_promotional_tweet_service = CreatePromotionalTweet.new(image_params)
    @promotional_tweet = @create_promotional_tweet_service.promotional_tweet
    if @create_promotional_tweet_service.enqueue_process
      render :show, status: :created
    else
      render json: { errors: @promotional_tweet.errors.messages }, status: :unprocessable_entity
    end
  end

  def post_tweet
    promo_tweet_id = { id: tweet_params[:promotional_tweet_id] }
    message = { message: tweet_params[:message] }
    @promotional_tweet = PromotionalTweet.update_or_create_by(promo_tweet_id, message)
  end

  def s3_upload
    @generate_upload_url_service = GenerateUploadUrl.new(upload_params[:filename])
    @url = @generate_upload_url_service.get_url

    respond_to do |format|
      format.json { 
        render json: { 
          url: @url, 
          content_type: @generate_upload_url_service.content_type 
        }
      }
    end
  end

  private

  def image_params
    params.require(:promotional_tweet).permit(:listen_signal_id, :direct_upload_url, :image_content_type, :image_file_name, :image_file_size)
  end

  def tweet_params
    params.require(:promotional_tweet).permit(:signal_id, :message, :promotional_tweet_id)
  end

  def upload_params
    params.require(:upload).permit(:filename)
  end
end



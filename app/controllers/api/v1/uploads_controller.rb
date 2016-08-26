class Api::V1::UploadsController < ApplicationController

  def signed_url
    @generate_upload_url_service = GenerateUploadUrl.new(create_params[:filename])
    @url = @generate_upload_url_service.call

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

  def create_params
    params.require(:upload).permit(:filename)
  end
end


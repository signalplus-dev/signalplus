class Api::V1::UploadsController < ApplicationController

  def signed_url
    @generate_upload_url_service = GenerateUploadUrl.new(create_params[:objectName])
    @url = @generate_upload_url_service.call

    respond_to do |format|
      format.json { render json: {signedUrl: @url} }
    end
  end

  private

  def create_params
    params.permit(:objectName)
  end
end


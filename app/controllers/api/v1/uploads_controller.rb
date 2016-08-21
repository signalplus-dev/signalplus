class Api::V1::UploadsController < ApplicationController

  def create
    @generate_upload_url_service = GenerateUploadUrl.new(create_params[:image_filename])
    @generate_upload_url_service.call
    render :show, status: :created
  end

  private

  def create_params
    params.require(:promotional_image).permit(:image_filename)
  end

end

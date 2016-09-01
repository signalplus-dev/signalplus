class GenerateUploadUrl

  attr_reader :content_type, :image_filename, :url

  # @example
  #   generate_upload_url_service = GenerateUploadUrl.new(filename)
  #   generate_upload_url_service.call
  #
  # @param filename [String]
  #
  def initialize(image_filename)
    @image_filename = image_filename
    @content_type   = MIME::Types.type_for(image_filename).first.content_type
  end

  # @return [Boolean] Generation successful
  def call
    s3 = Aws::S3::Resource.new()
    obj = s3.bucket(ENV['AWS_S3_IMAGE_BUCKET']).object("promotional-images/#{SecureRandom.uuid}/#{@image_filename}")
    URI.parse(obj.presigned_url(:put)).to_s
  end

end


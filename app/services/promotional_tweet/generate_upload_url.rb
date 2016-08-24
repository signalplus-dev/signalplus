class GenerateUploadUrl

  attr_reader :content_type, :image_filename, :url

  # @note It is important to have a single source of truth (Rails) for content-type, as
  #   clients may return mismatched content-types versus what Rails deduces, resulting in s3 signature errors.
  #
  # @example
  #   generate_upload_url_service = GenerateUploadUrl.new(filename)
  #   generate_upload_url_service.call
  #
  # @param filename [String]
  #
  def initialize(image_filename)
    @image_filename     = image_filename
    @content_type = MIME::Types.type_for(image_filename).first.content_type
  end

  # @return [Boolean] Generation successful
  def call
    obj = AWS::S3.new.
      buckets[ENV['AWS_S3_IMAGE_BUCKET']].
      objects["images/#{SecureRandom.uuid}/#{@image_filename}"]
    obj.url_for(:write, content_type: @content_type, acl: :public_read).to_s
  end

end


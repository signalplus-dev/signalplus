class TempImage
  def initialize(object_key)
    @object_key = object_key

    # Make the temp directory to store the image file
    folder_path.mkdir unless folder_path.exist?
  end

  def file
    @file ||= Tempfile.new([file_name, file_extension], folder_location, encoding: encoding).tap do |f|
      image_string_io.rewind
      f.write(image_string_io.read)
    end
  end

  private

  def s3_client
    @s3_client ||= Aws::S3::Client.new
  end

  def aws_object
    @aws_object ||= s3_client.get_object(bucket: ENV['AWS_S3_BUCKET'], key: @object_key)
  end

  def image_string_io
    aws_object.body
  end

  def timestamp
     Time.now.getutc.to_s.gsub(/\D/, '')
  end

  def path
    Pathname.new(@object_key)
  end

  def basename
    path.basename.to_s
  end

  def basename_parts
    basename.split('.')
  end

  def file_name
    "#{timestamp}_#{basename_parts[0..-[2, basename_parts.size].min].join('.')}"
  end

  def file_extension
    path.extname
  end

  def folder_location
    "#{Rails.root}/tmp/images"
  end

  def folder_path
    @folder_path ||= Pathname.new(folder_location)
  end

  def image_body
    image_string_io.rewind
    image_string_io.read
  end

  def encoding
    image_string_io.rewind
    image_string_io.read.encoding || Encoding::UTF_8
  end
end

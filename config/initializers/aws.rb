Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
})

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['AWS_S3_BUCKET'])

AWS.config(
  access_key_id:      ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY'],
  bucket:             ENV['AWS_S3_IMAGE_BUCKET']
)

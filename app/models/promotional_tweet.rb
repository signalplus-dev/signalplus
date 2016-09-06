# == Schema Information
#
# Table name: promotional_tweets
#
#  id                 :integer          not null, primary key
#  message            :text
#  listen_signal_id   :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class PromotionalTweet < ActiveRecord::Base
  belongs_to :listen_signal

  DIRECT_UPLOAD_URL_FORMAT = /\A(https:\/\/signal-twitter-images-development.s3.amazonaws.com\/promotional-images\/.+\/.+\.(jpg|png|jpeg))\z/

  enum status: { unprocessed: 0, processed: 1 }
  has_attached_file :image
  validates_format_of :direct_upload_url, with: DIRECT_UPLOAD_URL_FORMAT
  do_not_validate_attachment_file_type :image

  def self.update_or_create_by(args, attributes)
    promo_tweet = find_or_create_by(args)
    promo_tweet.update(attributes)
    promo_tweet
  end
end

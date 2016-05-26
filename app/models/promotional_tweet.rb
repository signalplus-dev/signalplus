class PromotionalTweet < ActiveRecord::Base
  belongs_to :listen_signal

  # Resize image
  has_attatched_file :image, styles: {
    medium: '300x300>'
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def save_image
  end

  def get_image
  end
end
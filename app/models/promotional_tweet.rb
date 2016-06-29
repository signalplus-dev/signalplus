class PromotionalTweet < ActiveRecord::Base
  belongs_to :listen_signal

  has_attached_file :image, :styles => {
    :medium => "300x300#",
    :thumb => "200x200#"
  }
  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

end
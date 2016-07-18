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

  has_attached_file :image, :styles => {
    :medium => "300x300#",
    :thumb => "200x200#"
  }
  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

end

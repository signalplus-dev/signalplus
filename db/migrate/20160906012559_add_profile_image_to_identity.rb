class AddProfileImageToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :profile_image_url, :string
  end
end

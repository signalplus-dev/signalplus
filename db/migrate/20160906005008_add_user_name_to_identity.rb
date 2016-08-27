class AddUserNameToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :user_name, :string
  end
end

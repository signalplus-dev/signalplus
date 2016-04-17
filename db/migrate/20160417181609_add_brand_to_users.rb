class AddBrandToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :brand, index: true, foreign_key: true
  end
end

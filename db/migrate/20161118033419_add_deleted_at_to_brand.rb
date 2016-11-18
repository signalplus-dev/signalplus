class AddDeletedAtToBrand < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :deleted_at, :datetime
  end
end

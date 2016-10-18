class AddTzToBrand < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :tz, :string
  end
end

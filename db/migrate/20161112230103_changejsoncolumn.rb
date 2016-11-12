class Changejsoncolumn < ActiveRecord::Migration[5.0]
  def change
    change_column :invoices, :data, :jsonb, null: false, default: {}

  end
end

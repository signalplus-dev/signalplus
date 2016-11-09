class InvoiceDataToJsoNb < ActiveRecord::Migration[5.0]
  def change
    remove_column :invoices, :data
    add_column :invoices, :data, :jsonb, null: false, default: '{}'
  end
end

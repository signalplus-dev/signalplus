class AddIndexToPaymentHandler < ActiveRecord::Migration[5.0]
  def change
    add_index :payment_handlers, :token
    change_column :invoices, :brand_id, :integer, null: false
  end
end

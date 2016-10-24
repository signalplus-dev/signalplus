class AddAmountToInvoices < ActiveRecord::Migration[5.0]
  def change
  	add_column :invoices, :amount, :integer
  end
end

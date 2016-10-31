class AddAmountToInvoices < ActiveRecord::Migration[5.0]
  def change
    remove_column :invoices, :paid, :boolean
    remove_column :invoices, :subscription_id, :integer

    add_column :invoices, :paid_at, :timestamp
    add_column :invoices, :amount, :integer
    add_column :invoices, :data, :string
  end
end

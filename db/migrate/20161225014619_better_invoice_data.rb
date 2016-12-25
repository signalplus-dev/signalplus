class BetterInvoiceData < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :period_start, :datetime
    add_column :invoices, :period_end, :datetime
    add_index  :invoices, :stripe_invoice_id, unique: true
    add_index  :invoices, :period_start
  end
end

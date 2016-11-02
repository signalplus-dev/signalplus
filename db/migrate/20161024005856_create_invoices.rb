class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string :stripe_invoice_id
      t.boolean :paid
      t.integer :brand_id
      t.integer :subscription_id

      t.timestamps
    end
  end
end

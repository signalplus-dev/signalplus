class CreateInvoiceAdjustments < ActiveRecord::Migration[5.0]
  def change
    create_table :invoice_adjustments do |t|
      t.references :invoice, index: true, foreign_key: true, null: false
      t.string     :stripe_invoice_item_id, null: false
      t.jsonb      :data, null: false, default: {}
      t.integer    :amount, null: false

      t.timestamps
    end

    add_index :invoice_adjustments, :stripe_invoice_item_id, unique: true
  end
end

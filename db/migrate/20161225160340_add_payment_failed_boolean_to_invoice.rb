class AddPaymentFailedBooleanToInvoice < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :payment_failed, :boolean, default: false
  end
end

class CreatePaymentHandlers < ActiveRecord::Migration
  def change
    create_table :payment_handlers do |t|
      t.references :brand, index: true
      t.string :provider
      t.string :token

      t.timestamps null: false
    end
  end
end

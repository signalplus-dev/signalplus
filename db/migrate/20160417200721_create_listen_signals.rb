class CreateListenSignals < ActiveRecord::Migration
  def change
    create_table :listen_signals do |t|
      t.references :brand, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.text :listen_to
      t.datetime :expiration_date
      t.boolean :active

      t.timestamps null: false
    end
  end
end

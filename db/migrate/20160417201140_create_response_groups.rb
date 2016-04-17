class CreateResponseGroups < ActiveRecord::Migration
  def change
    create_table :response_groups do |t|
      t.references :brand, index: true, foreign_key: true
      t.references :listen_signal, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

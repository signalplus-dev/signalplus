class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.text :message
      t.string :type
      t.references :response_group, index: true, foreign_key: true
      t.datetime :expiration_date

      t.timestamps null: false
    end
  end
end

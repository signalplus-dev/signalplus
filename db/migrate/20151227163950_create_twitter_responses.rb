class CreateTwitterResponses < ActiveRecord::Migration
  def change
    create_table :twitter_responses do |t|
      t.string  :from,     null: false
      t.string  :to,       null: false
      t.string  :hashtag,  null: false
      t.date    :date,     null: false
      t.integer :tweet_id, null: false

      t.timestamps         null: false
    end

    add_index :twitter_responses, [:from, :hashtag, :date]
    add_index :twitter_responses, [:from, :hashtag, :date, :to], unique: true
    add_index :twitter_responses, [:from, :tweet_id],            unique: true
  end
end

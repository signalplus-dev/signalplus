class CreatePromotionalTweet < ActiveRecord::Migration
  def change
    create_table :promotional_tweets do |t|
      t.text :message
      t.references :listen_signal, index: true, foreign_key: true
      t.timestamps :sent_at
      t.timestamps null: false
    end
  end
end

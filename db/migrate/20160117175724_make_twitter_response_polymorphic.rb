class MakeTwitterResponsePolymorphic < ActiveRecord::Migration
  def up
    add_column    :twitter_responses, :response_id, :bigint, null: false, default: 0
    add_column    :twitter_responses, :response_type, :string, null: false, default: 'Tweet'
    change_column :twitter_responses, :tweet_id, :integer, null: true
    remove_index  :twitter_responses, [:from, :tweet_id]
    add_index     :twitter_responses, [:from, :response_id, :response_type], unique: true, name: 'index_twitter_responses_on_from_and_response'

    update_sql = <<-SQL
      UPDATE twitter_responses
      SET (response_id, response_type) = (tweet_id, 'Tweet')
    SQL

    ActiveRecord::Base.connection.execute(update_sql.gsub(/\s+/, ' '))
  end

  def down
    remove_index  :twitter_responses, name: 'index_twitter_responses_on_from_and_response'
    remove_column :twitter_responses, :response_id
    remove_column :twitter_responses, :response_type
    change_column :twitter_responses, :tweet_id, :integer, null: false
    add_index     :twitter_responses, [:from, :tweet_id],  unique: true
  end
end

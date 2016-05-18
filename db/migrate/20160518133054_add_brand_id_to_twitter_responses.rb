class AddBrandIdToTwitterResponses < ActiveRecord::Migration
  def up
    add_reference :twitter_responses, :brand, index: true, foreign_key: true

    remove_index  :twitter_responses, name: "index_twitter_responses_on_from_and_hashtag_and_date_and_to"
    remove_index  :twitter_responses, name: "index_twitter_responses_on_from_and_hashtag_and_date"
    remove_index  :twitter_responses, name: "index_twitter_responses_on_from_and_response"
    remove_column :twitter_responses, :from

    add_index     :twitter_responses, [:brand_id, :hashtag, :date, :to], unique: true, name: 'index_twitter_responses_on_brand_and_hashtag_and_date_and_to'
    add_index     :twitter_responses, [:brand_id, :hashtag, :date], unique: true, name: 'index_twitter_responses_on_brand_and_hashtag_and_date'
    add_index     :twitter_responses, [:brand_id, :response_id, :response_type], unique: true, name: 'index_twitter_responses_on_brand_and_response'
  end
end

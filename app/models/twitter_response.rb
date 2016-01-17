# == Schema Information
#
# Table name: twitter_responses
#
#  id            :integer          not null, primary key
#  from          :string           not null
#  to            :string           not null
#  hashtag       :string           not null
#  date          :date             not null
#  tweet_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  response_id   :integer          not null
#  response_type :string           not null
#

class TwitterResponse < ActiveRecord::Base
  module ResponseType
    TWEET          = 'Tweet'
    DIRECT_MESSAGE = 'DirectMessage'
  end

  class << self
    def tweets
      where(response_type: ResponseType::TWEET)
    end

    def direct_messages
      where(response_type: ResponseType::DIRECT_MESSAGE)
    end

    def mass_insert_twitter_responses(date, from, hashtag, messages_to_respond_to)
      base_sql           = base_insert_statement(date, from, hashtag)
      base_insert_values = base_insert_values(date, from, hashtag)

      # Loop through the user_names and create valid value statements for each record that should be persisted
      insert_values = messages_to_respond_to.map do |message_info|
        new_insert_values     = base_insert_values.dup
        new_insert_values[-3] = "'#{message_info[:screen_name]}'"   # worry about sql injection later
        new_insert_values[-2] = message_info[:response_id].to_i     # worry about sql injection later
        new_insert_values[-1] = "'#{message_info[:response_type]}'" # worry about sql injection later
        "(#{new_insert_values.join(', ')})"
      end

      ActiveRecord::Base.connection.insert(base_sql + insert_values.join(', '))
    end

    # @return [Array<Symbol>] An array of attributes that should be assigned in the mass insert statement
    def twitter_response_mass_insert_attributes
      [
        :date,
        :from,
        :hashtag,
        :created_at,
        :updated_at,
        :to,
        :response_id,
        :response_type,
      ]
    end

    private

    # @return [String] A valid, sanitized sql statement for the
    def base_sql_statement(date, from, hashtag)
      arel_table
        .create_insert
        .tap { |im| im.insert(base_insert_attributes(date, from, hashtag)) }
        .to_sql
    end

    # @return [String] The base part of the insert statement, containing the all column declarations
    #                  that should be inserted.
    def base_insert_statement(date, from, hashtag)
      base_sql_statement(date, from, hashtag)[/^.+VALUES\s/]
    end

    # @return [Array] A base array containing all the similar insert portions of the mass insert statement
    def base_insert_values(date, from, hashtag)
      base_sql_statement(date, from, hashtag)[/(?<=VALUES\s\()[^\)]+/].split(', ')
    end

    # @return [Hash] A hash containing all the relevant insert data for the mass insert statement
    def base_insert_attributes(date, from, hashtag)
      base_twitter_response(date, from, hashtag).arel_mass_insert_attributes_for_create
    end

    # @return [TwitterResponse]
    def base_twitter_response(date, from, hashtag)
      current_time = Time.current

      new do |tr|
        tr.date       = date
        tr.from       = from
        tr.hashtag    = hashtag
        tr.created_at = current_time
        tr.updated_at = current_time
      end
    end
  end

  # @return [Hash] A hash containing all the relevant Arel data to create the insert statment for
  #                the unpersisted, dummy TwitterResponse object
  def arel_mass_insert_attributes_for_create
    arel_attributes_with_values_for_create(TwitterResponse.twitter_response_mass_insert_attributes)
  end
end

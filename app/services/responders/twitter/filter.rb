module Responders
  module Twitter
    class Filter
      attr_reader :brand, :tweet_messages, :grouped_responses

      # @param brand          [Brand]
      # @param tweet_messages [Array<Twitter::Tweet>|Twitter::Tweet]
      def initialize(brand, tweet_messages)
        @brand             = brand
        @tweet_messages    = tweet_messages.is_a?(Array) ? tweet_messages : [tweet_messages]
        @grouped_responses = build_grouped_responses
      end

      # @return [Responders::Twitter::Filter]
      def out_multiple_requests!
        grouped_responses.each do |hashtag, _|
          grouped_responses[hashtag].uniq! do |twitter_response|
            twitter_response.to
          end
        end

        self
      end

      # @return [Responders::Twitter::Filter]
      def out_users_already_responded_to!
        grouped_responses.each do |hashtag, twitter_responses|
          next if twitter_responses.empty?
          query_params               = twitter_responses.first.as_json.slice(:date, :from, :hashtag, :to)
          users_already_responded_to = TwitterResponse.where(query_params).pluck(:to)

          grouped_responses[hashtag].reject! do |twitter_response|
            users_already_responded_to.include?(twitter_response.to)
          end
        end

        self
      end

      private

      # @param hashtags [Array<Twitter::Entity::Hashtag>|Twitter::Entity::Hashtag]
      # @return         [Boolean]
      def listening_to_hashtags?(hashtags)
        hashtags = hashtags.is_a?(Array) ? hashtags : [hashtags]
        return false if hashtags.empty?

        hashtags.any? do |hashtag_obj|
          hashtags_being_listened_to.include?(hashtag_obj.text.downcase)
        end
      end

      # @return [Array<String>]
      def hashtags_being_listened_to
        # Should eventually be brand.signals.active.pluck(:name).map(&:downcase)
        @hashtags_being_listened_to ||= Listener::HASHTAGS_TO_LISTEN_TO.keys.map(&:downcase)
      end

      # @return [Hash<String, Array<Responders::Twitter::Response>>]
      def build_grouped_responses
        twitter_responses = tweet_messages.map do |message|
          messages = message.hashtags.map do |hashtag|
            Response.build(brand: brand, message: message, hashtag: hashtag.text) if listening_to_hashtags?(hashtag)
          end

          messages.compact
        end

        twitter_responses.flatten!

        twitter_responses.group_by do |twitter_response|
          twitter_response.hashtag
        end
      end
    end
  end
end

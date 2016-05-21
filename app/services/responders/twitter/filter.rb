module Responders
  module Twitter
    class Filter
      attr_reader :brand, :tweet_messages, :grouped_replies

      # @param brand          [Brand]
      # @param tweet_messages [Array<Twitter::Tweet>|Twitter::Tweet]
      def initialize(brand, tweet_messages)
        @brand             = brand
        @tweet_messages    = tweet_messages.is_a?(Array) ? tweet_messages : [tweet_messages]
        @grouped_reply     = build_grouped_replies
      end

      # @return [Responders::Twitter::Filter]
      def out_multiple_requests!
        grouped_rreplies.each do |hashtag, _|
          grouped_replies[hashtag].uniq! do |twitter_reply|
            twitter_reply.to
          end
        end

        self
      end

      # @return [Responders::Twitter::Filter]
      def out_users_already_responded_to!
        grouped_replies.each do |hashtag, twitter_replies|
          next if twitter_replies.empty?
          query_params               = twitter_replies.first.as_json.slice(:date, :from, :hashtag, :to)
          users_already_responded_to = TwitterReply.where(query_params).pluck(:to)

          grouped_replies[hashtag].reject! do |twitter_reply|
            users_already_responded_to.include?(twitter_reply.to)
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

      # @return [Hash<String, Array<Responders::Twitter::Reply>>]
      def build_grouped_replies
        twitter_replies = tweet_messages.map do |message|
          messages = message.hashtags.map do |hashtag|
            Reply.build(brand: brand, message: message, hashtag: hashtag.text) if listening_to_hashtags?(hashtag)
          end

          messages.compact
        end

        twitter_replies.flatten!

        twitter_replies.group_by do |twitter_reply|
          twitter_reply.hashtag
        end
      end
    end
  end
end

module Responders
  module Twitter
    class Filter
      attr_reader :brand, :tweet_messages, :grouped_replies

      UNIQUE_REPLY_PARAMS_PER_DAY_PER_RESPONSE = [
        :date,
        :brand_id,
        :listen_signal_id,
        :to,
        :response_id,
      ]

      # @param brand          [Brand]
      # @param tweet_messages [Array<Twitter::Tweet>|Twitter::Tweet]
      def initialize(brand, tweet_messages)
        @brand           = brand
        @tweet_messages  = tweet_messages.is_a?(Array) ? tweet_messages : [tweet_messages]
        @grouped_replies = build_grouped_replies
      end

      # @return [Responders::Twitter::Filter]
      def out_multiple_requests!
        grouped_replies.each do |hashtag, _|
          grouped_replies[hashtag].uniq! do |twitter_reply|
            twitter_reply.to
          end
        end

        self
      end

      # @return [Responders::Twitter::Filter]
      def out_users_already_replied_to!
        grouped_replies.each do |hashtag, twitter_replies|
          next if twitter_replies.empty?
          query_params               = twitter_replies.first.as_json.slice(*UNIQUE_REPLY_PARAMS_PER_DAY_PER_RESPONSE)
          users_already_responded_to = TwitterResponse.where(query_params).pluck(:to)

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
          !!active_listen_signals[hashtag_obj.text.downcase]
        end
      end

      # @return [Hash<String, ListenSignal>]
      def active_listen_signals
        @listen_signals ||= brand.listen_signals.active.group_by do |ls|
          ls.name.downcase
        end
      end

      # @return [Hash<String, Array<Responders::Twitter::Reply>>]
      def build_grouped_replies
        twitter_replies = tweet_messages.map do |message|
          messages = message.hashtags.map do |hashtag|
            listen_signal = active_listen_signals[hashtag.text.downcase].try(:first)
            Reply.build(brand: brand, message: message, listen_signal: listen_signal) if listen_signal
          end
          messages.compact
        end

        twitter_replies.flatten!

        twitter_replies.group_by do |twitter_reply|
          twitter_reply.listen_signal.id
        end
      end
    end
  end
end

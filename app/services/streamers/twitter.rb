module Streamers
  class Twitter
    attr_reader :brand, :tweet_tracker, :dm_tracker

    def initialize(brand)
      raise StandardError.new('No tweet tracker') unless brand.tweet_tracker
      raise StandardError.new('No direct message tracker') unless brand.twitter_dm_tracker

      @brand         = brand
      @tweet_tracker = brand.tweet_tracker
      @dm_tracker    = brand.twitter_dm_tracker
    end

    def stream!
      brand.twitter_streaming_client.user do |object|
        return if brand.reload.stop_twitter_streaming?

        case object
        when ::Twitter::Tweet, ::Twitter::DirectMessage
          process_message(object)
        when ::Twitter::Streaming::StallWarning
          Rollbar.warning(e)
        end
      end
    end

    private

    def process_message(message)
      sender = message.is_a?(::Twitter::Tweet) ? message.user : message.sender
      return if sender.id == brand.twitter_id

      begin
        puts "Received a #{message.class.to_s.demodulize}!"
        puts "Message text: #{message.text}"
        filter = Responders::Twitter::Filter.new(brand, message)
        filter.out_multiple_requests!
        filter.out_users_already_responded_to!
        grouped_responses = filter.grouped_responses
        response          = grouped_responses.first.try(:last).try(:first)
        tracker           = message.is_a?(::Twitter::Tweet) ? tweet_tracker : dm_tracker
        if should_respond?(grouped_responses, response)
          TwitterResponseWorker.perform_async(brand.id, response.as_json)
        end

        UpdateTrackerWorker.perform_async(tracker.id, tracker.class.to_s, message.id)
      rescue StandardError => e
        Rollbar.error(e)
      end
    end

    def should_respond?(grouped_responses, response)
      grouped_responses.any? && response.present?
    end
  end
end

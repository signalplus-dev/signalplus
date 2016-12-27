require 'twitter'

module Twitter
  module Streaming
    class Connection
      def stream(request, response)
        client_context = OpenSSL::SSL::SSLContext.new
        port           = request.uri.port || Addressable::URI::PORT_MAPPING[request.uri.scheme]
        client         = @tcp_socket_class.new(Resolv.getaddress(request.uri.host), port)
        ssl_client     = @ssl_socket_class.new(client, client_context)

        ssl_client.connect
        request.stream(ssl_client)
        while body = ssl_client.readpartial(1024) # rubocop:disable AssignmentInCondition
          response << body
        end
      end
    end
  end
end

def should_sleep?(error)
  error.kind_of?(Twitter::Error::TooManyRequests) &&
  error.code == Twitter::Error::Code::RATE_LIMIT_EXCEEDED
end

desc "Listens to a user's stream of mentions and direct messages"
task twitter_stream: :environment do
  brand = Brand.find(ENV['BRAND_ID'])

  # Kill any old processes
  brand.kill_streaming_process!

  sleep 1
  Process.setproctitle(brand.process_name)

  loop do
    begin
      brand.streaming_tweets!(Process.pid)
    rescue StandardError => e
      # Reload the brand to find if it should stop streaming tweets
      brand.reload

      if brand.stop_twitter_streaming?
        Rails.logger.info('Stopping twitter stream')
        break
      else
        # Should ignore Sigterm
        Rails.logger.info('Recording error for listening to twitter stream')
        Rollbar.error(e, brand_id: brand.id)

        # Turn on polling implementation
        brand.update!(polling_tweets: true)

        scheduled_jobs = Sidekiq::ScheduledSet.new
        twitter_cron_job = scheduled_jobs.find do |j|
          j.item['class'] == TwitterCronJob.to_s
        end

        # Start polling implementation immediately
        twitter_cron_job.add_to_queue if twitter_cron_job

        # Check if we are being rate limited from Twitter
        if should_sleep?(e)
          Rails.logger.info("Being rate limited by Twitter")
          time_to_restart = error.rate_limit.attrs['x-rate-limit-reset'].to_i
          sleep_time = [(Time.at(time_to_restart) - Time.current).to_i, 0].max
          Rails.logger.info("Brand ##{brand.id} twitter stream is sleeping for #{sleep_time} seconds")
          sleep sleep_time
        end
      end
    end
  end
end

module TwitterHelper
  def should_sleep?(error)
    error.kind_of?(Twitter::Error::TooManyRequests) &&
    error.code == Twitter::Error::Code::RATE_LIMIT_EXCEEDED
  end

  # Check if we are being rate limited from Twitter
  def rate_limit_check(error)
    if should_sleep?(error)
      Rails.logger.info("Being rate limited by Twitter")
      time_to_restart = error.rate_limit.attrs['x-rate-limit-reset'].to_i
      sleep_time = [(Time.at(time_to_restart) - Time.current).to_i, 0].max
      Rails.logger.info("Brand ##{brand.id} twitter stream is sleeping for #{sleep_time} seconds")
      sleep sleep_time
    end
  end
end

module TwitterHelper
  def should_sleep?(error)
    error.respond_to?(:rate_limit) &&
    error.rate_limit.respond_to?(:retry_after) &&
    !!error.rate_limit.retry_after
  end

  # Check if we are being rate limited from Twitter
  def rate_limit_check(error, brand)
    if should_sleep?(error)
      Rails.logger.info("Being rate limited by Twitter")
      sleep_time = error.rate_limit.retry_after
      Rails.logger.info("Brand ##{brand.id} twitter stream is sleeping for #{sleep_time} seconds")
      sleep sleep_time
    end
  end
end

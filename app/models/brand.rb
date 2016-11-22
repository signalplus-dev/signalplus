# == Schema Information
#
# Table name: brands
#
#  id                  :integer          not null, primary key
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  streaming_tweet_pid :integer
#  polling_tweets      :boolean          default(FALSE)
#  tz                  :string           default("America/New_York"), not null
#

class Brand < ActiveRecord::Base
  acts_as_paranoid

  VALID_TIMEZONES = ActiveSupport::TimeZone.all.map { |tz| tz.tzinfo.name }

  has_many :users, dependent: :destroy
  has_many :identities
  has_many :admin_users, through: :identities, source: :user
  has_many :listen_signals, dependent: :destroy
  has_many :response_groups, through: :listen_signals
  has_many :twitter_responses
  has_many :monthly_twitter_responses, -> { paid.for_this_month }, class_name: 'TwitterResponse'
  has_many :invoices

  has_one :twitter_identity, -> { where(provider: Identity::Provider::TWITTER) }, class_name: 'Identity'
  has_one :twitter_admin, through: :twitter_identity, source: :user
  has_one :tweet_tracker,      class_name: 'TwitterTracker'
  has_one :twitter_dm_tracker, class_name: 'TwitterDirectMessageTracker'
  has_one :payment_handler
  has_one :subscription, dependent: :destroy

  after_create :create_trackers

  validate :time_zone_is_valid

  class << self
    # @param brand_id [Fixnum]
    # @return         [ActiveRecord::Relation]
    def find_with_trackers(brand_id)
      includes(:tweet_tracker, :twitter_dm_tracker)
        .where(id: brand_id)
        .first
    end

    def twitter_cron_job_query
      where(polling_tweets: true).select(:id)
    end

    def twitter_streaming_query
      joins(:listen_signals).merge(ListenSignal.active).select(:id).distinct
    end
  end

  def get_token_info(provider)
    encrypted_token  = identities.where(provider: provider).first.encrypted_token
    encrypted_secret = identities.where(provider: provider).first.encrypted_secret

    keys = {
      provider: provider,
      token:    Identity.decrypt(encrypted_token),
      secret:   Identity.decrypt(encrypted_secret)
    }
  end

  # Twitter provider specific methods

  # @return [Twitter::REST::Client]
  def twitter_rest_client
    @twitter_rest_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TW_KEY']
      config.consumer_secret     = ENV['TW_SECRET']
      config.access_token        = twitter_identity.decrypted_token
      config.access_token_secret = twitter_identity.decrypted_secret
    end
  end

  # @return [Twitter::Streaming::Client]
  def twitter_streaming_client
    @twitter_streaming_client ||= Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV['TW_KEY']
      config.consumer_secret     = ENV['TW_SECRET']
      config.access_token        = twitter_identity.decrypted_token
      config.access_token_secret = twitter_identity.decrypted_secret
    end
  end

  # @return [Fixnum|Bignum]
  def twitter_id
    twitter_identity.uid.to_i
  end

  # @return [String]
  def tweet_url(tweet_id)
    "https://twitter.com/#{user_name}/status/#{tweet_id}"
  end

  # @return [String]
  def user_name
    twitter_identity.try(:user_name)
  end

  # @return [String]
  def profile_image_url
    twitter_identity.try(:profile_image_url)
  end

  def turn_off_twitter_polling!
    update!(polling_tweets: false)
  end

  def streaming_tweets!(pid)
    update!(streaming_tweet_pid: pid)

    Time.use_zone(tz) do
      Streamers::Twitter.new(self).stream!
    end
  end

  def turn_off_twitter_streaming!
    update!(streaming_tweet_pid: nil)
  end

  # @return [Boolean]
  def currently_streaming_twitter?
    !stop_twitter_streaming?
  end

  # @return [Boolean]
  def stop_twitter_streaming?
    streaming_tweet_pid.nil?
  end

  # @return [Boolean]
  def turn_on_twitter_streaming?
    !currently_streaming_twitter? && has_active_signals?
  end

  # @return [Boolean]
  def turn_off_twitter_streaming?
    currently_streaming_twitter? && !has_active_signals?
  end

  # @return [Boolean]
  def has_active_signals?
    @has_active_signals ||= listen_signals.active.exists?
  end

  # @return [Boolean]
  def subscription?
    subscription.present?
  end

  # @return [String]
  def process_name
    "twitter_stream_#{id}"
  end

  def kill_streaming_process!
    `killall #{process_name}`
  end

  # @return [Fixnum]
  def monthly_response_count
    monthly_twitter_responses.count
  end

  def broadcast_monthly_response_count!
    ActionCable.server.broadcast(
      "monthly_response_count_#{id}",
      monthly_response_count: monthly_response_count
    )
  end

  # @return [Boolean]
  def surpassed_trial_message_count?
    monthly_response_count > Subscription::MAX_NUMBER_OF_MESSAGES_FOR_TRIAL
  end

  # @return [Boolean]
  def in_trial?
    !!subscription.try(:trial?)
  end

  def delete_account
    ActiveRecord::Base.transaction do
      unsubscribe_users_from_newsletter
      subscription.cancel_plan!
      destroy!
    end
  end

  def unsubscribe_users_from_newsletter
    users.each do |user|
      user.update!(email_subscription: false) if user.email_subscription
    end
  end

  private

  def create_trackers
    TwitterTracker.create(brand_id: id)
    TwitterDirectMessageTracker.create(brand_id: id)
  end

  def time_zone_is_valid
    time_zone = ActiveSupport::TimeZone.new(tz)
    raise StandardError.new('Not a valid time zone') if time_zone.nil?
  rescue StandardError
    errors.add(:tz, 'is not valid')
  end
end

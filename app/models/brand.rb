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
#  tz                  :string
#

class Brand < ActiveRecord::Base
  acts_as_paranoid

  has_many :users
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
  has_one :subscription

  after_create :create_trackers

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

  def tweet_url(tweet_id)
    "https://twitter.com/#{self.user_name}/status/#{tweet_id}"
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
    Streamers::Twitter.new(self).stream!
  end

  def turn_off_twitter_streaming!
    update!(streaming_tweet_pid: nil)
  end

  def currently_streaming_twitter?
    !stop_twitter_streaming?
  end

  def stop_twitter_streaming?
    streaming_tweet_pid.nil?
  end

  def turn_on_twitter_streaming?
    !currently_streaming_twitter? && has_active_signals?
  end

  def turn_off_twitter_streaming?
    currently_streaming_twitter? && !has_active_signals?
  end

  def has_active_signals?
    @has_active_signals ||= listen_signals.active.exists?
  end

  def subscription?
    subscription.present?
  end

  def process_name
    "twitter_stream_#{id}"
  end

  def kill_streaming_process!
    `killall #{process_name}`
  end

  def monthly_response_count
    monthly_twitter_responses.count
  end

  def broadcast_monthly_response_count!
    ActionCable.server.broadcast(
      "monthly_response_count_#{id}",
      monthly_response_count: monthly_response_count
    )
  end

  private

  def create_trackers
    TwitterTracker.create(brand_id: id)
    TwitterDirectMessageTracker.create(brand_id: id)
  end
end

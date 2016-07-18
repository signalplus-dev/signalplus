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
#

class Brand < ActiveRecord::Base
  has_many :users
  has_many :identities
  has_many :admin_users, through: :identities, source: :user
  has_many :listen_signals
  has_many :response_groups, through: :listen_signals

  has_one :twitter_identity, -> { where(provider: Identity::Provider::TWITTER) }, class_name: 'Identity'
  has_one :twitter_admin, through: :twitter_identity, source: :user
  has_one :tweet_tracker,      class_name: 'TwitterTracker'
  has_one :twitter_dm_tracker, class_name: 'TwitterDirectMessageTracker'
  has_one :payment_handler

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
      where.not(streaming_tweet_pid: nil).select(:id)
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

  private

  def create_trackers
    TwitterTracker.create(brand_id: id)
    TwitterDirectMessageTracker.create(brand_id: id)
  end
end

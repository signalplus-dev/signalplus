class EmailRemoveSubscriptionWorker
  include Sidekiq::Worker

  def perform(encrypted_email)
    list_id = ENV['MAILCHIMP_NEWSLETTER_LIST_ID']
    gb = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])

    gb.lists(list_id).members(encrypted_email).update(
      body: { status: 'unsubscribed'}
    )
  end
end

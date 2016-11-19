class EmailRemoveSubscriptionWorker
  include Sidekiq::Worker

  IGNORABLE_ERROR_CODES = [
    404,
  ]

  def perform(encrypted_email)
    list_id = ENV['MAILCHIMP_NEWSLETTER_LIST_ID']
    gb = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])

    gb.lists(list_id).members(encrypted_email).update(
      body: { status: 'unsubscribed'}
    )
  rescue Gibbon::MailChimpError => e
    # Check if we should ignore the MailChimp error status code
    unless IGNORABLE_ERROR_CODES.include?(e.status_code)
      raise
    end
  end
end

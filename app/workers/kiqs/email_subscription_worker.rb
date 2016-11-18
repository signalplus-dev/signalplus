class EmailSubscriptionWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    return unless user.present?

    encrypted_email = user.encrypted_email
    list_id = ENV['MAILCHIMP_NEWSLETTER_LIST_ID']
    gb = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])

    gb.lists(list_id).members(user.encrypted_email).upsert(
      body: {
        email_address: user.email,
        status: 'subscribed',
        merge_fields: {
          FNAME: user.brand.name,
          LNAME: user.name
        }
      }
    )
  end
end

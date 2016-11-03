class Email::Subscription
  attr_reader :user, :list_id, :encrypted_email

  def initialize(user)
    @user = user
    @list_id = ENV['MAILCHIMP_NEWSLETTER_LIST_ID']
    @encrypted_email = encrypt_email_address
  end

  def subscribe
    EmailSubscriptionWorker.perform_async(user, list_id, encrypted_email)
  end

  def unsubscribe
    EmailRemoveSubscriptionWorker.perform_async(user, list_id, encrypted_email)
  end

  private

  def encrypt_email_address
    Digest::MD5.hexdigest(user.email.downcase)
  end
end

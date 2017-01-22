class TransactionalEmail
  extend TransactionalMailers

  attr_reader :template_name, :brand, :to, :merge_params, :message

  module Types
    WELCOME = 'welcome-email'
    CHANGE  = 'plan-change'
    CANCEL  = 'cancel-plan'
  end

  REPLY_TO_EMAIL = 'info@signalplus.com'

  def initialize(template_name, brand, merge_params)
    @template_name = template_name
    @brand = brand
    @merge_params = merge_params
    @to = brand.twitter_admin.try(:email)
    @message = get_message
  end

  def send
    begin
      MANDRILL_CLIENT.messages.send_template(template_name, [], message)
    rescue Mandrill::Error => e
      Rollbar.error(e, brand_id: brand.id)
    end
  end

  private

  def get_message
    {
      tags: [template_name],
      merge_vars: [{ rcpt: to, vars: merge_params }],
      merge_language: 'mailchimp',
      merge: true,
      headers: { 'Reply-To': REPLY_TO_EMAIL },
      to: [{ type: 'to', email: to }],
      track_opens: true,
    }
  end
end

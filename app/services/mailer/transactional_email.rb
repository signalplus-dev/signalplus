require 'mandrill'

class TransactionalEmail
  extend TransactionalMailers

  attr_reader :mandrill, :template_name, :brand, :to, :merge_params, :message

  module Types
    WELCOME = 'welcome-email'
    CHANGE  = 'plan-change'
    CANCEL  = 'cancel-plan'
  end

  MANDRILL = Mandrill::API.new(ENV['MANDRILL_API_KEY'])

  def initialize(template_name, brand, merge_params)
    @mandrill = MANDRILL
    @template_name = template_name
    @brand = brand
    @merge_params = merge_params
    @to = brand.twitter_admin.email
    @message = get_message
  end

  def send
    begin
      mandrill.messages.send_template(template_name, [], message)
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
      headers: { 'Reply-To': 'info@signalplus.com' },
      to: [{ type: 'to', email: to }],
      track_opens: true,
    }
  end
end

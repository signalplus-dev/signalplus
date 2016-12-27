require 'mandrill'

class TransactionalEmail
  attr_reader :mandrill, :template_name, :brand, :merge_params, :message

  module Types
    WELCOME     = 'welcome'
    PLAN_CHANGE = 'plan-change'
    CANCEL_PLAN = 'cancel-plan'
  end

  def initialize(template_name, brand)
    @mandrill = Mandrill::API.new(ENV['MANDRILL_API_KEY'])
    @template_name = template_name
    @brand = brand
    @to = brand.twitter_admin.email
    @email_attributs = get_email_attributes
    @message = get_message
  end

  def send
    begin
      @mandrill.messages.send_template(@template_name, @message)
    rescue Mandrill::Error => e
      Rollbar.error(e)
    end
  end

  private

  def get_message
    {
      'tags': @template_name,
      'merge_vars': [{
        'rcpt': @to,
        'vars': @email_attributes
      }],
     'merge_language': 'mailchimp',
     'merge': true,
     'headers': {
        'Reply-To'=>'info@signalplus.com'
      },
     'to': [{
        'type': 'to',
        'email': @to
      }],
     'track_opens': true,
     'async': true
    }
  end

  def get_email_attributes
    default_opt = [
      {
        'name': 'BRAND_HASHTAG',
        'content': @brand.name
      },
      {
        'name': 'PLAN_NAME',
        'content': @brand.subscription_plan_name
      }
    ]

    date_attr = get_plan_attr
    if date_attr.present?
      default_opt << {
        'name': 'PLAN_DATE',
        'content': date_attr
      }
    end

    default_opt
  end

  def get_date_attr
    if @teamplate_name == Types::PLAN_CHANGE
      @brand.subscription.updated_at.to_date
    elsif @template_name == Types::CANCEL_PLAN
      @brand.subscription.will_be_deactivated_at.to_date
    end
  end
end

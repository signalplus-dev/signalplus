class UserMailer < BaseMandrillMailer
  def welcome(brand)
    email = brand.twitter_admin.email

    subject = 'Welcome to SignalPlus'
    merge_vars = {
      'BRAND_HASHTAG': brand.name,
      'SELECTED_PLAN_NAME': brand.subscription_plan.name,
    }
    body = mandrill_template('welcome', merge_vars)

    send_mail(email, subject, body)
  end

  # TODO Verify subscription start date = updated date
  def plan_change(brand)
    email = brand.twitter_admin.email

    subject = 'Update on your plan'
    merge_vars = {
      'BRAND_HASHTAG': brand.name,
      'UPDATED_PLAN_NAME': brand.subscription_plan.name,
      'UPDATED_PLAN_START_DATE': brand.subscription.updated_at.to_date,
    }
    body = mandrill_template('plan-change', merge_vars)

    send_mail(email, subject, body)
  end

  #TODO Grab the last day of the subscription when canceling and pass it down
  def cancel_plan(brand)
    email = brand.twitter_admin.email

    subject = 'Confirmation on your plan'
    merge_vars = {
      'BRAND_HASHTAG': brand.name,
      'CANCELED_PLAN_NAME': brand.subscription_plan.name
      # 'CANCELED_PLAN_END_DATE': subscription_plan.name,
    }
    body = mandrill_template('cancel-plan', merge_vars)

    send_mail(email, subject, body)
  end

end


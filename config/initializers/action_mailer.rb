Rails.application.configure do
  config.action_mailer.smtp_settings = {
    address: ENV["MANDRILL_HOST"],
    port: ENV["MANDRILL_PORT"],
    enable_starttls_auto: true,
    user_name: ENV["MANDRILL_USERNAME"],
    password: ENV["MANDRILL_API_KEY"],
    authentication: 'login'
  }
end

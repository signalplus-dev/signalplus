if Rails.env.development? || Rails.env.test?
  Spring.watch("#{Rails.root}/config/application.yml")
end

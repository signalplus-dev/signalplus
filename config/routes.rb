Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidetiq/web'

  mount Sidekiq::Web => '/sidekiq'
end

Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'sidetiq/web'

  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }

  get 'users/index'
  root 'users#index'

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

end

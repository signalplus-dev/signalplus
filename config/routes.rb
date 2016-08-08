Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidetiq/web'

  mount Sidekiq::Web => '/sidekiq'


  get 'users/index'
  root 'users#index'

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }

  get 'dashboard/get_data' => 'dashboard#get_data'
  get 'dashboard/index'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end
end

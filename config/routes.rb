Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidetiq/web'

  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  
  root 'users#index'
  get 'users/index'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  get 'about'   => 'dashboard#about'
  get 'guide'   => 'dashboard#guide'
  get 'support' => 'dashboard#support'

  get 'dashboard/index'
  get 'dashboard/get_data' => 'dashboard#get_data'
  put 'template/signal'    => 'listen_signals#edit_signal'
  post 'template/signal'   => 'listen_signals#create_template_signal'

  post 'post_tweet', to: 'listen_signals#post_tweet'


  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
    end
    namespace :v1, defaults: { format: 'json' } do
      resources :promotional_tweets, only: [:index, :create]
      get 'uploads', to: 'uploads#signed_url'
    end
  end
end

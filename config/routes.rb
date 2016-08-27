Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidetiq/web'

  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  post '/users/refresh_token' => 'users#refresh_token'

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

  namespace :api do
    namespace :v1, defaults: { format: 'json' } do
      # Testing endpoint for authentication
      get '/test' => 'base#test' if Rails.env.test?

      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        sessions: 'api/v1/sessions',
      }

      resources :promotional_tweets, only: [:index, :create]

      get 'uploads', to: 'uploads#signed_url'
      post 'post_tweet', to: 'promotional_tweets#post_tweet'

      resources :subscriptions, only: [:create]
      resources :brands, only: [:show] do
        get '/me' => 'brands#show', on: :collection
      end
    end
  end
end

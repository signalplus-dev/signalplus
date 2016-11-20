Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidetiq/web'

  mount Sidekiq::Web => '/sidekiq'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }

  root 'users#index'
  get 'users/index'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  get 'about'   => 'dashboard#about'
  get 'guide'   => 'dashboard#guide'
  get 'support' => 'dashboard#support'

  resources :dashboard, only: [:index]

  namespace :api do
    namespace :v1, defaults: { format: 'json' } do
      # Testing endpoint for authentication
      get '/test' => 'base#test' if Rails.env.test?
      post '/token' => 'base#token'

      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        sessions: 'api/v1/sessions',
      }

      resources :promotional_tweets, only: [:index, :create]
      resources :subscriptions, only: [:create, :update]
      resources :subscription_plans, only: [:index]
      resources :invoices, only: [:index]
      resources :listen_signals, only: [:index, :show, :create, :update, :destroy] do
        get :templates, on: :collection
      end
      resources :users, only: [] do
        get '/me' => 'users#show', on: :collection
        post :update, on: :member
      end
      resources :brands, only: [] do
        get '/me' => 'brands#show', on: :collection
        get '/account_plans' => 'brands#account_plans', on: :collection
        post '/account_info' => 'brands#update_account_info', on: :collection
      end
    end
  end

  namespace :webhooks do
    namespace :stripe, defaults: { format: 'json' } do
      resources :invoices, only: :create do
        post '/charge' => 'invoices#charge_event', on: :collection
      end
    end
  end

  get 'subscription_plans' => 'dashboard#index', as: :subscription_plans

  # Catch all for any routes nested with `/dashboard`. Any non-existant routes will be handled by the React app.
  get 'dashboard/*other' => 'dashboard#index'
end

# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'api/v1/auth/registrations',
    sessions: 'api/v1/auth/sessions',
  }
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :admin do
        resources :users
        resources :topics, only: [:create, :update, :destroy]
        resources :authors, only: [:create, :update, :destroy]
        resources :articles, only: [:create, :update, :destroy]
      end
      resources :topics, only: [:index, :show]
      resources :authors, only: [:index, :show]
      resources :articles, only: [:index, :show] do
        get 'live_articles_search', to: 'articles#live_articles_search', on: :collection
      end
    end
  end
end

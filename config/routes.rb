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
      end
    end
  end
end

Rails.application.routes.draw do
  # Auth routes
  resources :users, only: [ :new, :create ]
  resource :session

  # Generate API token
  resource :api_token, only: [ :show, :create, :destroy ]

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "api_tokens#show"
end

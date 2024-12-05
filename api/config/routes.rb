Rails.application.routes.draw do
  apipie
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post "login", to: "login"
        get "me", to: "me"
      end

      namespace :wallet do
        get "", to: "index"
        get "history", to: "history"
        post "deposit", to: "deposit"
        post "transfer", to: "transfer"
        post "withdraw", to: "withdraw"
        get "list", to: "list"
      end

      namespace :transaction do
        get "", to: "index"
      end
    end
  end

  namespace :web do
    namespace :auth do
      get "", to: "index"
    end
  end
end

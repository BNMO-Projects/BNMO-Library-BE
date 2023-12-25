Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :auth do
      # Authentication routes
      resources :login, only: [:create]
      resources :register, only: [:create]
    end

    namespace :admin do
      resources :book_management, path: "/book-management"

      namespace :master_data, path: "/master-data" do
        resources :authors
        resources :categories
        resources :genres
        resources :languages
      end
    end
  end
end

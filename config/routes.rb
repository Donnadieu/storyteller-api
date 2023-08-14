Rails.application.routes.draw do
  use_doorkeeper
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :oauth do
      post "google", controller: :google, action: :create
      get "google", controller: :google, action: :index
      post "apple", controller: :apple, action: :create
      get "apple", controller: :apple, action: :index
      get "apple/token", controller: :apple, action: :token
    end

    namespace :v1 do
      namespace :webhooks do
        namespace :apple do
          resources :notifications, only: %i[create]
        end
      end
    end
  end

  draw(:flipper)
end

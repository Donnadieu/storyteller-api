Rails.application.routes.draw do
  use_doorkeeper
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :oauth do
      post "google", controller: :google, action: :create
      get "google", controller: :google, action: :index
    end
  end

  draw(:flipper)
end

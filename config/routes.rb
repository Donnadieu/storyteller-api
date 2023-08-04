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
    namespace :v1 do
      resources :stories, only: [:create, :update, :index, :show, :destroy]
    end
  end
end

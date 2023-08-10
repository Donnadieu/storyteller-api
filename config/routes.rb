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

    constraints HasRestrictedAccessConstraint do
      mount Flipper::Api.app(Flipper) => '/flipper' # Docs: https://www.flippercloud.io/docs/api
    end
  end

  # TODO: Get this working - the constraint for accessing /admin/flipper still doesn't work on local. we need this
  #   to allow admins on specific networks access the flipper UI
  scope :admin, as: :admin, constraints: HasRestrictedAccessConstraint do
    mount Flipper::UI.app(Flipper) => '/flipper' # Docs: https://www.flippercloud.io/docs/api
  end
end

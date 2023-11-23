# frozen_string_literal: true

require 'admin_scope_constraint'
require 'sidekiq/web'

scope :admin, as: :admin do
  constraints AdminScopeConstraint.new do
    # Setting up sidekiq web: https://github.com/sidekiq/sidekiq/wiki/Monitoring#web-ui
    mount Sidekiq::Web => '/sidekiq'
  end
end

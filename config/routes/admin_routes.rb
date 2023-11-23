# frozen_string_literal: true

require_relative '../../lib/admin_scope_constraint'
require 'sidekiq/web'
require 'sidekiq/cron/web'

scope :admin, as: :admin do
  constraints AdminScopeConstraint.new do
    # Setting up sidekiq web: https://github.com/sidekiq/sidekiq/wiki/Monitoring#web-ui
    mount Sidekiq::Web => '/sidekiq'
  end
end

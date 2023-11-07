# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require_relative '../lib/stackdriver_utils'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StorytellerApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.time_zone = 'Eastern Time (US & Canada)'

    config.extra_load_paths = [
      'lib/tasks'
    ].map { |path| Rails.root.join(path).to_s }
    config.autoload_paths += config.extra_load_paths
    config.eager_load_paths += config.extra_load_paths

    # # Stackdriver Google Cloud Logging: https://github.com/googleapis/google-cloud-ruby/blob/main/stackdriver/INSTRUMENTATION_CONFIGURATION.md
    # StackdriverUtils.setup if StackdriverUtils.enabled?

    config.log_tags = { request_id: :request_id, ip: :remote_ip }

    # Flipper mount options
    config.flipper.mount_options = {}

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Configure admin emails
    config.admin_emails = config_for(:admins)[:emails]

    # Configure admin remote IP addresses
    config.admin_remote_ips = config_for(:admins)[:ip_addresses]

    # Configure allowed hosts. See doc https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization
    config.hosts += config_for(:allowed_hosts)

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end

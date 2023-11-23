# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do |app|
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  config.log_level = :debug

  # Doc for Stackdriver on local: https://cloud.google.com/logging/docs/setup/ruby#run-local
  unless LoggerUtils::Stackdriver.enabled?
    config.google_cloud.use_trace = false
    config.google_cloud.use_logging = false
    config.google_cloud.use_error_reporting = false
    config.google_cloud.use_debugger = false
  end

  # Wrapping the initialization of the logtail appender in a before_initialize
  # seems to resolve the SSL error described below.
  config.before_initialize do
    LoggerUtils::Stackdriver.setup if LoggerUtils::Stackdriver.enabled?

    if LoggerUtils::BetterStack.enabled?
      # TODO: Setup logtail appender occasionally fails on startup with an SSL error:
      #   "OpenSSL::SSL::SSLError: SSL_read: sslv3 alert bad record mac"
      #   the error seems related to forking (multiple processes). Here's a thread on
      #   SO that might help resolve the issue: https://stackoverflow.com/a/51384262
      logtail_appender = SemanticLogger::Appender::Http.new(
        url: 'https://in.logs.betterstack.com',
        ssl: { verify: OpenSSL::SSL::VERIFY_NONE },
        header: {
          'Content-Type': 'application/json',
          Authorization: "Bearer #{app.credentials.logtail.source_token}"
        }
      )
      SemanticLogger.add_appender(appender: logtail_appender)
    end
  end

  # # Setup BetterStack (FKA Loggtail) on Rails without Semantic Logger: https://betterstack.com/docs/logs/ruby-and-rails/#2-setup
  # config.logger = Logtail::Logger.create_default_logger(app.credentials.logtail.source_token)

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Flipper mount options
  config.flipper.mount_options = {
    rack_protection: {
      except: %i[authenticity_token form_token json_csrf remote_token http_origin session_hijacking]
    }
  }

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
end

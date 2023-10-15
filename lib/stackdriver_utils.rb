# frozen_string_literal: true

require 'fileutils'

# Helper methods for configuring Stackdriver: https://github.com/googleapis/google-cloud-ruby/blob/main/stackdriver/INSTRUMENTATION_CONFIGURATION.md
module StackdriverUtils
  class << self
    # Documentation for stackdriver setup: https://cloud.google.com/logging/docs/setup/ruby#run-local
    def setup
      return if config.private_key.nil?
      return if config.private_key.credential.nil?

      # Write out GCP credentials in server instance
      unless File.exist?(private_key_file)
        File.open(private_key_file, 'w') do |file|
          file.write(config.private_key.credential)
        end
      end

      # Set stackdriver keyfile
      app.config.google_cloud.keyfile = private_key_file

      # Other configuration options
      app.config.google_cloud.project_id = config.project_id
      app.config.google_cloud.use_logging = enabled?
      app.config.google_cloud.use_trace = enabled?
      app.config.google_cloud.use_error_reporting = enabled?
      app.config.google_cloud.logging.log_name = "storysprout-api-#{Rails.env}"
      app.config.google_cloud.logging.labels = { environment: Rails.env }
      app.config.google_cloud.trace.capture_stack = true
    end

    def enabled?
      @enabled ||= %w[1 yes true].include?(ENV.fetch('STACKDRIVER_ENABLED', true).to_s) ||
                   Rails.env.production?
    end

    private

    def private_key_file
      Rails.root.join('config', 'credentials', "#{config.private_key.name}.json").to_s
    end

    def config
      app.credentials.google_cloud
    end

    def app
      Rails.application
    end
  end
end

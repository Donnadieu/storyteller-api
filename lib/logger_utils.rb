# frozen_string_literal: true

require 'fileutils'

# Helper methods for configuring Stackdriver: https://github.com/googleapis/google-cloud-ruby/blob/main/stackdriver/INSTRUMENTATION_CONFIGURATION.md
module LoggerUtils
  class Stackdriver
    class << self
      def setup
        return if config.private_key.nil?
        return if config.private_key.credential.nil?

        # TODO: This writes out GCP credentials in server instance, but we should ideally
        #   use a service account instead provisioned with a secure key store like the
        #   built in credentials encrypted file for Rails. This is a temporary solution.
        #   We should look into other modes of authentication via the service account for
        #   the GCP project. Alternatively, we can explore options for mounting these
        #   credentials in the app instance container(s) as supported by our app platform.
        # Docs on GCP application default credentials (ADC): https://cloud.google.com/docs/authentication/application-default-credentials
        # Docs on mounting credentials: https://cloud.google.com/docs/authentication/application-default-credentials#personal
        unless File.exist?(private_key_file)
          File.open(private_key_file, 'w') do |file|
            file.write(config.private_key.credential)
          end
        end

        # Stackdriver shared configurations
        app.config.google_cloud.project_id = config.project_id
        app.config.google_cloud.keyfile = private_key_file

        # Logging configurations
        app.config.google_cloud.logging.log_name = "storysprout-api-#{Rails.env}"
        app.config.google_cloud.logging.log_name_map = {
          '/api/v1/health' => 'ruby_health_check_log'
        }
        app.config.google_cloud.use_logging = enabled?

        # Error reporting configurations
        app.config.google_cloud.use_error_reporting = enabled?

        # Trace configurations
        app.config.google_cloud.trace.capture_stack = true
        app.config.google_cloud.use_trace = enabled?
      end

      def enabled?
        @enabled ||= %w[1 yes true].include?(ENV.fetch('STACKDRIVER_ENABLED', false).to_s)
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

  class BetterStack
    class << self
      def enabled?
        @enabled ||= %w[1 yes true].include?(ENV.fetch('BETTERSTACK_ENABLED', true).to_s)
      end
    end
  end
end

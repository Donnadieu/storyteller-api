# frozen_string_literal: true

# Helper methods for working with feature flags
module FeatureFlagUtils
  class << self
    def initialized?
      ActiveRecord::Base.connection.table_exists? :flipper_features
    end

    def setup_defaults
      return if Rails.env.test?

      return unless defined? Flipper

      %i[
        feat__apple_login
        feat__story_builder_service
      ].each do |feat_name|
        Flipper.enable(feat_name) unless Flipper.exist?(feat_name)
      end
    end

    def log_status(actor = nil)
      Flipper.features.each do |feature|
        enabled = actor.nil? ? feature.enabled? : feature.enabled?(actor)
        Rails.logger.info "📦Feature [#{feature.name}] is #{enabled ? 'enabled' : 'disabled'}"
      end
    end
  end
end

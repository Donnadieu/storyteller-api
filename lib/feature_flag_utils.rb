# frozen_string_literal: true

module FeatureFlagUtils
  class << self
    def initialized?
      ActiveRecord::Base.connection.table_exists? :flipper_features
    end

    def setup_defaults
      return if Rails.env.test?

      return unless defined? Flipper

      [:feat__apple_login].each do |feat_name|
        Flipper.enable(feat_name) unless Flipper.exist?(feat_name)
      end
    end
  end
end

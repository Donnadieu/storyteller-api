# frozen_string_literal: true

require File.expand_path('../../lib/feature_flag_utils', __dir__)

Flipper.configure do |config|
  config.adapter { Flipper::Adapters::ActiveRecord.new }

  if FeatureFlagUtils.initialized?
    FeatureFlagUtils.setup_defaults
    FeatureFlagUtils.log_status
  end
end

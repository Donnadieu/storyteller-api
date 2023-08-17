require File.expand_path("../../../lib/feature_flag_utils", __FILE__)

Flipper.configure do |config|
  config.default do
    adapter = Flipper::Adapters::ActiveRecord.new
    Flipper.new(adapter)
  end

  FeatureFlagUtils.setup_defaults if FeatureFlagUtils.initialized?
end

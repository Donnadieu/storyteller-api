# frozen_string_literal: true

require 'redis_connection'

Sidekiq.configure_server do |config|
  config.redis = RedisConnection.connection_params
end

Sidekiq.configure_client do |config|
  config.redis = RedisConnection.connection_params
end

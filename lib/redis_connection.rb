# frozen_string_literal: true

class RedisConnection
  class << self
    def app
      @app ||= Redis::Namespace.new('storysprout.app', redis: connection)
    end

    def connection_params
      {
        url: redis_url,
        ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
      }
    end

    def client
      @client ||= Redis.new(url: redis_url)
    rescue Redis::CannotConnectError => error
      log_error error.message
    end

    private

    def redis_url
      @redis_url ||= ENV.fetch('REDIS_TLS_URL', Rails.application.credentials.redis.url)
    end
  end
end

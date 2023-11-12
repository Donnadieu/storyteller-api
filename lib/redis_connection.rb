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
      return @redis_url if defined?(@redis_url)

      @redis_url ||= ENV.fetch('REDIS_TLS_URL', ENV.fetch('REDIS_URL', nil))
      @redis_url ||= 'redis://localhost:6379'
    end
  end
end

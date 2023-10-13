# frozen_string_literal: true

module Api
  module V1
    class HealthController < ApplicationController
      def index
        render json: { message: 'API is healthy' }
      end

      def heartbeat
        # TODO: Add logic to return response time for the API
        head :not_implemented
      end
    end
  end
end

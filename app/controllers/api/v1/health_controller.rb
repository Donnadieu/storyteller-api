# frozen_string_literal: true

module Api
  module V1
    class HealthController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :doorkeeper_authorize!

      def index
        render json: { status: 'OK', message: 'API is healthy' }
      end
    end
  end
end

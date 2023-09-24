# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api/v1/health', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get api_v1_health_url, as: :json
      expect(response).to have_http_status(:ok)
    end
  end
end

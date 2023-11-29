# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/oauth/apple', type: :request do
  before do
    Rails.application.load_seed
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:valid_app) do
        Doorkeeper::Application.find_by(name: 'StorySprout')
      end
      let(:valid_attributes) do
        {
          code: 'valid_code',
          id_token: 'valid_id_token',
          client_id: valid_app.uid,
          client_secret: valid_app.secret
        }
      end
      let(:mock_id_token) { double(AppleID::IdToken) }
      let(:mock_access_token) { double(AppleID::AccessToken) }

      before do
        # TODO: Fix the following exception when running this test:
        #   RSpec::Mocks::MockExpectationError: #<Double AppleID::IdToken> received unexpected message :each_pair with (no args)
        #   0) /api/oauth/apple POST /create with valid parameters creates a new User
        #      Failure/Error: result = OnBoardSingleSignOnUser.call(@id_token)
        #        #<Double AppleID::IdToken> received unexpected message :each_pair with (no args)
        #      # ./app/controllers/api/oauth/apple_controller.rb:39:in `create'
        #      # ./spec/requests/api/oauth/apple_spec.rb:35:in `block (4 levels) in <top (required)>'
        allow(mock_access_token).to receive(:id_token) { mock_id_token }
        allow(mock_access_token).to receive(:access_token) { 'mock_access_token' }
        allow(mock_id_token).to receive(:aud) { 'app.storysprout.web.auth' }
        allow(mock_id_token).to receive(:verify!) { true }
        allow_any_instance_of(AppleID::Client).to receive(:access_token!) { mock_access_token }
      end

      it 'creates a new User' do
        post api_oauth_apple_url, params: valid_attributes, as: :json
      end
    end
  end
end

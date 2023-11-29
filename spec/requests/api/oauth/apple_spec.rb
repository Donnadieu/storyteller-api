# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/oauth/apple', type: :request do
  before do
    Rails.application.load_seed
  end

  around do |example|
    Sidekiq::Testing.inline!
    example.run
    Sidekiq::Testing.fake!
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

      context 'for a new account' do
        let(:mock_user_id_data) do
          {
            iss: 'apple',
            name: Faker::Name.name,
            email: Faker::Internet.email
          }
        end
        let(:mock_id_token) { double(AppleID::IdToken) }
        let(:mock_access_token) { double(AppleID::AccessToken) }
        let(:mock_welcome_email) { double(TransactionalEmail::Welcome) }

        before do
          allow(mock_access_token).to receive(:id_token) { mock_id_token }
          allow(mock_access_token).to receive(:access_token) { 'mock_access_token' }
          allow(mock_id_token).to receive(:aud) { 'app.storysprout.web.auth' }
          allow(mock_id_token).to receive(:as_json) { mock_user_id_data }
          allow(mock_id_token).to receive(:verify!) { true }
          allow_any_instance_of(AppleID::Client).to receive(:access_token!) { mock_access_token }
          allow(mock_welcome_email).to receive(:send!)
          allow(TransactionalEmail::Welcome).to receive(:new) { mock_welcome_email }
        end

        subject do
          User.find_by_email mock_user_id_data[:email]
        end

        it 'sends a welcome email and on-boards a new user' do
          expect do
            post api_oauth_apple_url, params: valid_attributes, as: :json
          end.to change { User.count }.by(1)
          perform_enqueued_jobs
          expect(mock_welcome_email).to have_received(:send!).once
          expect(subject.active?).to be(true)
        end
      end
    end
  end
end

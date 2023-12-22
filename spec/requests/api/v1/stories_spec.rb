# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe 'api/v1/stories', type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Story. As you add validations to Story, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      story: {
        subbject: Faker::Lorem.sentence,
        hero: Faker::Name.name,
        place: Faker::Address.city,
        character: Faker::Name.name,
        object: Faker::Lorem.word,
        age: Faker::Number.number(digits: 2)
      }
    }
  end

  let(:invalid_attributes) do
    {
      story: {
        title: nil,
        description: nil
      }
    }
  end

  let(:doorkeeper_access_token) do
    FactoryBot.create(:doorkeeper_access_token)
  end

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # StoriesController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) do
    {
      Authorization: "Bearer #{doorkeeper_access_token.token}"
    }
  end

  let(:invalid_headers) do
    {
      Authorization: 'Bearer invalid_token'
    }
  end

  describe 'GET /index' do
    context 'when the user is authenticated' do
      it "renders a the user's stories" do
        FactoryBot.create_list(:user_story, 10, user_id: doorkeeper_access_token.resource_owner_id)

        get api_v1_stories_url, headers: valid_headers, as: :json

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(JSON.parse(response.body).size).to eq(10)
      end

      it "does not render other users' stories" do
        10.times do
          FactoryBot.create(:user_story)
        end

        get api_v1_stories_url, headers: valid_headers, as: :json

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(JSON.parse(response.body).size).to eq(0)
      end
    end

    context 'when the user is not authenticated' do
      it 'renders a JSON response with status unauthorized' do
        get api_v1_stories_url, headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /create' do
    before do
      allow_any_instance_of(OpenAI::Client).to receive(:completions) {
                                                 { 'choices' => [{ 'text' => 'Once upon a time' }] }
                                               }
    end

    context 'when the user is authenticated' do
      context 'and valid parameters' do
        it 'creates a new Story with a new UserStory' do
          post api_v1_stories_url,
               params: valid_attributes,
               headers: valid_headers,
               as: :json

          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including('application/json'))
          expect(Story.count).to eq(1)
          expect(Story.first.description).to eq('Once upon a time')
          expect(UserStory.count).to eq(1)
          expect(UserStory.first.user_id).to eq(doorkeeper_access_token.resource_owner_id)
          expect(UserStory.first.story_id).to eq(Story.first.id)
        end
      end

      context 'and invalid parameters' do
        before do
          allow_any_instance_of(OpenAI::Client).to receive(:completions) { { 'choices' => [{ 'text' => '' }] } }
        end

        it 'does not create a new UserStory' do
          expect do
            post api_v1_stories_url,
                 params: { user_story: invalid_attributes }, as: :json
          end.to change(UserStory, :count).by(0)
        end

        it 'renders a JSON response with errors for the new user_story' do
          post api_v1_stories_url,
               params: invalid_attributes, headers: valid_headers, as: :json

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including('application/json'))
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'renders a JSON response with status unauthorized' do
        post api_v1_stories_url,
             params: valid_attributes,
             headers: invalid_headers,
             as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /update' do
    before do
      FactoryBot.create(:user_story, user_id: doorkeeper_access_token.resource_owner_id)
    end

    context 'when the user is authenticated' do
      it 'returns not found' do
        patch api_v1_story_url(1), headers: valid_headers, as: :json
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the user is not authenticated' do
      it 'returns unauthorized' do
        patch api_v1_story_url(1), headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

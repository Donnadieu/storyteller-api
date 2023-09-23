# frozen_string_literal: true

FactoryBot.define do
  factory :doorkeeper_access_token, class: 'Doorkeeper::AccessToken' do
    application
    resource_owner_id { FactoryBot.create(:user).id }
    scopes { 'public' }
    expires_in { 2.hours }
    use_refresh_token { true }
  end
end

# frozen_string_literal: true

require 'sib-api-v3-sdk'

SibApiV3Sdk.configure do |config|
  config.api_key['api-key'] = Rails.application.credentials.brevo.api_key
end

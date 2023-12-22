# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from Errors::Unauthorized,
              Errors::IDTokenVerificationFailed,
              Errors::AccessTokenRequestFailed,
              with: :unauthorized

  rescue_from Errors::UnprocessableEntity,
              with: :unprocessable_entity

  rescue_from ActiveRecord::RecordNotFound,
              with: :resource_not_found

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def unauthorized
    render json: {
      status: 'error'
    }, status: 401
  end

  def unprocessable_entity
    render json: {
      status: 'error'
    }, status: 422
  end

  def resource_not_found
    render json: {
      status: 'error'
    }, status: 404
  end
end

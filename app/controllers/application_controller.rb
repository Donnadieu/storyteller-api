class ApplicationController < ActionController::API
  rescue_from Errors::Unauthorized,
              Errors::IDTokenVerificationFailed,
              Errors::AccessTokenRequestFailed,
              with: :unauthorized

  rescue_from Errors::UnprocessableEntity,
              with: :unprocessable_entity

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def unauthorized
    render json: {
      status: "error"
    }, status: 401
  end

  def unprocessable_entity
    render json: {
      status: "error"
    }, status: 422
  end
end

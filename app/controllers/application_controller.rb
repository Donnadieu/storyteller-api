class ApplicationController < ActionController::API
  rescue_from Errors::Unauthorized,
              Errors::IDTokenVerificationFailed,
              Errors::AccessTokenRequestFailed,
              with: :unauthorized

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

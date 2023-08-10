class Api::Oauth::GoogleController < ApplicationController
  include Authorizable

  before_action :authorize_client, only: [:create]
  before_action :verify_id_token, only: [:create]

  GOOGLE_AUTH_ERRORS = [
    Google::Auth::IDTokens::AudienceMismatchError,
    Google::Auth::IDTokens::ExpiredTokenError,
    Google::Auth::IDTokens::SignatureError,
  ].freeze

  def create
    @user = User.find_or_create_from_auth_hash(@id_token)
    raise Errors::Unauthorized unless @user.persisted?

    initialize_access_token!

    render json: {
      user: JSON.parse(@user.to_json),
      access_token: @access_token.token,
      refresh_token: @access_token.refresh_token,
      token_type: 'bearer',
      created_at: @access_token.created_at.to_i
    }, status: :created
  end

  private

  def auth_params
    params.permit(
      :credential,
      :client_id,
      :client_secret
    )
  end

  def verify_id_token
    payload = Google::Auth::IDTokens.verify_oidc(
      auth_params[:credential],
      aud: Rails.application.credentials.google.client_id
    )

    if payload['aud'] == Rails.application.credentials.google.client_id
      @id_token = payload
    else
      head :unauthorized
    end

    rescue *GOOGLE_AUTH_ERRORS => e
      head :unauthorized
  end
end

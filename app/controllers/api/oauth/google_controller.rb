class Api::Oauth::GoogleController < ApplicationController
  before_action :authorize_client, only: [:create]
  before_action :verify_id_token, only: [:create]

  GOOGLE_AUTH_ERRORS = [
    Google::Auth::IDTokens::AudienceMismatchError,
    Google::Auth::IDTokens::ExpiredTokenError,
    Google::Auth::IDTokens::SignatureError,
  ].freeze

  def create
    @user = User.find_or_create_from_auth_hash(@id_token)

    if @user.persisted?
      @access_token = Doorkeeper::AccessToken.create!(
        application_id: @client.id,
        resource_owner_id: @user.id,
        scopes: 'public',
        use_refresh_token: true
      )

      render json: {
        user: JSON.parse(@user.to_json),
        access_token: @access_token.token,
        refresh_token: @access_token.refresh_token,
        token_type: 'bearer',
        refresh_token: @access_token.refresh_token,
        created_at: @access_token.created_at.to_i
      }, status: :created
    else
      head :unauthorized
    end
  end

  private

  def auth_parmams
    params.permit(
      :credential,
      :client_id,
      :client_secret
    )
  end

  def authorize_client
    app = Doorkeeper::Application.find_by(
      uid: auth_parmams[:client_id],
      secret: auth_parmams[:client_secret]
    )

    if app.nil?
      head :unauthorized
    else
      @client = app
    end
  end

  def verify_id_token
    payload = Google::Auth::IDTokens.verify_oidc(
      auth_parmams[:credential],
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

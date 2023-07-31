class Api::Oauth::AppleController < ApplicationController
  before_action :setup_client, only: %i[create]

  def index
    head 501
  end

  def create
    return unprocessable_entity unless params[:code].present? && params[:identity_token].present?

    @client.authorization_code = params[:code]

    begin
      token_response = @client.access_token!
    rescue AppleID::Client::Error => e
      puts e # gives useful messages from apple on failure
      return unauthorized
    end

    id_token_back_channel = token_response.id_token
    id_token_back_channel.verify!(
      client: @client,
      access_token: token_response.access_token,
    )

    id_token_front_channel = AppleID::IdToken.decode(params[:identity_token])
    id_token_front_channel.verify!(client: @client, code: params[:code])

    id_token = token_response.id_token

  end

  private

  def verify_id_token

  end

  def created
    render json: {
      status: "success",
      data: @user
    }, status: 201
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

  def setup_client
    @client ||= AppleID::Client.new(
      identifier: client_credentials.client_id,
      team_id: client_credentials.team_id,
      key_id: client_credentials.key_id,
      private_key: OpenSSL::PKey::EC.new(client_credentials.key_pem),
      redirect_uri: client_credentials.redirect_uri
    )
  end

  def client_credentials
    @client_credentials ||= Rails.application.credentials.apple
  end
end

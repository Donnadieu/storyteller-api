# Sample project: https://github.com/nov/signin-with-apple
class Api::Oauth::AppleController < ApplicationController
  attr_accessor :token_response, :id_token

  before_action :setup_client, only: %i[create]

  def index
    head 501
  end

  def token
    # TODO: implement access token workflow
    head 501
  end

  def create
    return unprocessable_entity unless params[:code].present? && params[:id_token].present?

    begin
      verify_back_channel_id_token!
      verify_front_channel_id_token!
    rescue AppleID::Client::Error => e
      puts e # gives useful messages from apple on failure
      return unauthorized
    end

    if @id_token_back_channel&.aud == client_credentials.client_id
      @id_token = @id_token_back_channel
    else
      return unauthorized
    end

    head 201
  end

  private

  def verify_back_channel_id_token!
    id_token, code = params.values_at :id_token, :code
    return if id_token.nil? || code.nil?

    @client.authorization_code = code
    @token_response = @client.access_token!
    @id_token_back_channel = token_response.id_token
    @id_token_back_channel.verify!(
      client: @client,
      access_token: token_response.access_token,
    )
  end

  def verify_front_channel_id_token!
    return if params[:id_token].nil?

    @id_token_front_channel = AppleID::IdToken.decode(params[:id_token])
    @id_token_front_channel.verify!(client: @client, code: params[:code])
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
      # redirect_uri: "https://storysprout.ngrok.app",
      redirect_uri: client_credentials.redirect_uri
    )
  end

  def client_credentials
    @client_credentials ||= Rails.application.credentials.apple
  end

  def jwt
    private_key = OpenSSL::PKey::EC.new(client_credentials.key_pem)
    header = { alg: 'ES256', kid: JWT::JWK.new(private_key)[:kid] }
    payload = {
      iss: client_credentials.team_id,
      iat: Time.current.utc.to_i,
      exp: 2.weeks.from_now.utc.to_i,
      aud: 'https://appleid.apple.com',
      sub: client_credentials.client_id
    }
    # https://developer.apple.com/documentation/sign_in_with_apple/generate_and_validate_tokens#3262048
    JWT.encode payload, private_key, 'ES256', header
  end
end

module Authorizable
  extend ActiveSupport::Concern

  attr_accessor :access_token

  def authorize_client
    app = Doorkeeper::Application.find_by(
      uid: auth_params[:client_id],
      secret: auth_params[:client_secret]
    )

    if app.nil?
      raise Errors::Unauthorized
    end

    @client = app
  end

  def initialize_access_token!
    return if @client.nil?

    @access_token = Doorkeeper::AccessToken.create!(
      application_id: @client.id,
      resource_owner_id: @user.id,
      scopes: 'public',
      use_refresh_token: true
    )
  end

  protected

  def auth_params
    raise NotImplementedError, "#{self.class.name} MUST implement :auth_params method"
  end
end

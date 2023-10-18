# frozen_string_literal: true

Doorkeeper::JWT.configure do
  # Set the payload for the JWT token. This should contain unique information
  # about the user. Defaults to a randomly generated token in a hash:
  #     { token: "RANDOM-TOKEN" }
  token_payload do |opts|
    user = User.find(opts[:resource_owner_id])

    {
      iss: 'api/oauth',
      iat: Time.current.utc.to_i,
      exp: 1.day.from_now.utc.to_i, # TODO: Make this configurable
      aud: opts[:application][:uid],

      # @see JWT reserved claims - https://tools.ietf.org/html/draft-jones-json-web-token-07#page-7
      jti: SecureRandom.uuid,
      # Hash the id to avoid sending the user id in the clear
      sub: Digest::SHA256.hexdigest(user.id.to_s),

      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        image: user.image,
        provider: user.provider
      }
    }
  end
  # rubocop:disable Layout/LineLength

  # Optionally set additional headers for the JWT. See
  # https://tools.ietf.org/html/rfc7515#section-4.1
  # JWK can be used to automatically verify RS* tokens client-side if token's kid matches a public kid in /oauth/discovery/keys
  # token_headers do |_opts|
  #   key = OpenSSL::PKey::RSA.new(File.read(File.join('path', 'to', 'file.pem')))
  #   { kid: JWT::JWK.new(key)[:kid] }
  # end

  # Use the application secret specified in the access grant token. Defaults to
  # `false`. If you specify `use_application_secret true`, both `secret_key` and
  # `secret_key_path` will be ignored.
  use_application_secret false

  # Set the encryption secret. This would be shared with any other applications
  # that should be able to read the payload of the token. Defaults to "secret".
  secret_key Rails.application.credentials.jwt_secret_key

  # If you want to use RS* encoding specify the path to the RSA key to use for
  # signing. If you specify a `secret_key_path` it will be used instead of
  # `secret_key`.
  # secret_key_path File.join('path', 'to', 'file.pem')

  # Specify encryption type (https://github.com/progrium/ruby-jwt). Defaults to
  # `nil`.
  encryption_method :hs256

  # rubocop:enable Layout/LineLength
end

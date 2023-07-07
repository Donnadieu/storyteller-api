class User < ApplicationRecord
  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  def self.find_or_create_from_auth_hash(auth_hash)
    provider = auth_hash['provider']
    uid = auth_hash['uid']
    token = auth_hash['credentials']['token']
    refresh_token = auth_hash['credentials']['refresh_token']
    expires_at = auth_hash['credentials']['expires_at']
    name = auth_hash['info']['name']
    nickname = auth_hash['info']['nickname']
    image = auth_hash['info']['image']
    email = auth_hash['info']['email']

    User.find_or_create_by(provider: provider, uid: uid) do |user|
      user.name = name
      user.nickname = nickname
      user.image = image
      user.email = email
      user.token = token
      user.refresh_token = refresh_token
      user.expires_at = expires_at
    end
  end
end
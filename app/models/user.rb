# frozen_string_literal: true

class User < ApplicationRecord
  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :user_stories
  has_many :stories, through: :user_stories

  validates :provider, presence: true
  validates :email, presence: true

  def self.find_or_create_from_auth_hash(auth_hash)
    provider = auth_hash['iss']
    name = auth_hash['name']
    image = auth_hash['picture']
    email = auth_hash['email']

    User.find_or_create_by(provider:, email:) do |user|
      user.name = name
      user.image = image
      user.email = email
      user.provider = provider
    end
  end

  def admin?
    Rails.application.config.admin_emails.include? email
  end
end

# frozen_string_literal: true

class OnBoardSingleSignOnUser
  include Interactor

  after do
    context.user.finished_onboarding! unless context.user.active?
  end

  def call
    provider, name, image, email = context.to_h.values_at :iss, :name, :image, :email
    context.user = User.find_or_create_by(provider:, email:) do |user|
      user.name = name
      user.image = image
      user.email = email
      user.provider = provider
    end

    context.fail!(message: "#{provider.to_s.humanize} user was not authorized") \
      unless context.user.errors.none? && context.user.persisted?
  end
end


# frozen_string_literal: true

require_relative '../../lib/flipper_resources_constraint'

namespace :api do
  constraints FlipperResourcesConstraint.new do
    mount Flipper::Api.app(Flipper) => '/flipper' # Docs: https://www.flippercloud.io/docs/api
  end
end

scope :admin, as: :admin do
  # Solution configuring rack_protection https://github.com/flippercloud/flipper/issues/99#issuecomment-659822238
  constraints FlipperResourcesConstraint.new do
    mount Flipper::UI.app(Flipper, Rails.application.config.flipper.mount_options), at: '/flipper'
  end
end

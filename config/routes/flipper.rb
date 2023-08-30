# Doc on advanced constraints https://guides.rubyonrails.org/routing.html#advanced-constraints
flipper_constraint = lambda { |request|
  case request.path
  when /\/admin\/flipper\/(css|js)\//
    return true
  when /\/api\/flipper\/features/, /\/api\/flipper\/actors\/Users;\d+/
    return request.method == 'GET'
  else
    if request.forwarded_for.nil?
      return Rails.application.config.admin_remote_ips.include?(request.remote_ip)
    end
    # Checks to see if any of the remote ips captured for the request are in the admin_remote_ips array
    (Rails.application.config.admin_remote_ips & request.forwarded_for).any?
  end
}

namespace :api do
  constraints flipper_constraint do
    mount Flipper::Api.app(Flipper) => '/flipper' # Docs: https://www.flippercloud.io/docs/api
  end
end

scope :admin, as: :admin do
  # Solution configuring rack_protection https://github.com/flippercloud/flipper/issues/99#issuecomment-659822238
  constraints flipper_constraint do
    mount Flipper::UI.app(Flipper, Rails.application.config.flipper.mount_options), at: '/flipper'
  end
end

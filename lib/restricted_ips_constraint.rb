# frozen_string_literal: true

class RestrictedIpsConstraint
  def initialize
    @ips = Rails.application.config.admin_remote_ips
  end

  def matches?(request)
    return @ips.include?(request.remote_ip) if request.forwarded_for.nil?

    # Checks to see if any of the remote ips captured for the request are in the admin_remote_ips array
    (@ips & request.forwarded_for).any?
  end
end

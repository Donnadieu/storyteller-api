# Doc on advanced constraints https://guides.rubyonrails.org/routing.html#advanced-constraints

require_relative 'restricted_ips_constraint'

class FlipperResourcesConstraint
  def initialize
    @restricted_ips_constraint = RestrictedIpsConstraint.new
  end

  def matches?(request)
    case request.path
    when /\/admin\/flipper\/(css|js)\//
      return true
    when /\/api\/flipper\/features/, /\/api\/flipper\/actors\/Users;\d+/
      return request.method == 'GET'
    else
      return @restricted_ips_constraint.matches?(request)
    end
  end
end

# frozen_string_literal: true

# Doc on advanced constraints https://guides.rubyonrails.org/routing.html#advanced-constraints

require_relative 'restricted_ips_constraint'

class FlipperResourcesConstraint
  def initialize
    @restricted_ips_constraint = RestrictedIpsConstraint.new
  end

  def matches?(request)
    case request.path
    when %r{/admin/flipper/(css|js)/}
      true
    when %r{/api/flipper/features}, %r{/api/flipper/actors/Users;\d+}
      request.method == 'GET'
    else
      @restricted_ips_constraint.matches?(request)
    end
  end
end

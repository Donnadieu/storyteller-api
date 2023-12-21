# frozen_string_literal: true

require 'restricted_ips_constraint'

class AdminScopeConstraint
  def initialize
    @restricted_ips_constraint = RestrictedIpsConstraint.new
  end

  def matches?(request)
    @restricted_ips_constraint.matches?(request)
  end
end

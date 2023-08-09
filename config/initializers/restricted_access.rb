class HasRestrictedAccessConstraint
  def self.matches?(request)
    return true if Rails.env.development?

    current_user = request.env['warden'].user
    current_user.present? && current_user.respond_to?(:admin?) && current_user.admin?
  end
end

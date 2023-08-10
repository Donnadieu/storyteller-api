class HasRestrictedAccessConstraint
  def self.matches?(_request)
    return true if Rails.env.development?

    # TODO: retrieve current_user from doorkeeper, perhaps using CurrentAttributes https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html
    # current_user.present? && current_user.respond_to?(:admin?) && current_user.admin?
    false
  end
end

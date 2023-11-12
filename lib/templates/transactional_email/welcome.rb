# frozen_string_literal: true

module TransactionalEmail
  class Welcome
    # TODO: Include support for GlobalID
    def initialize(email: nil, name: nil, user_id: nil)
      @user = User.find(user_id) unless user_id.nil?
      @recipients ||= []

      if defined?(@user)
        @recipients << SibApiV3Sdk::SendSmtpEmailTo.new(
          name: @user.name, email: @user.email
        )
      end

      if @recipients.none?
        raise ArgumentError, 'Email address is required if user is unknown' if email.nil?

        @recipients << SibApiV3Sdk::SendSmtpEmailTo.new(name:, email:)
      end
    end

    def send!
      email = SibApiV3Sdk::SendSmtpEmail.new(
        to: @recipients,
        template_id: self.class.template_id,
        params: { SHOW_SOCIAL_LINKS: false }
      )
      api_instance = SibApiV3Sdk::TransactionalEmailsApi.new
      # Returns a boolean if the email is sent successfully
      api_instance.send_transac_email(email)
    rescue SibApiV3Sdk::ApiError => e
      Rails.logger.error "Exception when calling TransactionalEmailsApi->send_transac_email: #{e}"
    end

    def self.template_id
      1
    end
  end
end

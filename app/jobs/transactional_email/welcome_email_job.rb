# frozen_string_literal: true

module TransactionalEmail
  class WelcomeEmailJob < ApplicationJob
    def perform(user_id)
      # Do something
    end
  end
end

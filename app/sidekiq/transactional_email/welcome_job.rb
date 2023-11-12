# frozen_string_literal: true

module TransactionalEmail
  class WelcomeJob
    include Sidekiq::Job

    def perform(user_id)
      # Do something
    end
  end
end

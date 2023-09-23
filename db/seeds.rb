# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create Doorkeeper Applications
puts 'Creating Doorkeeper Applications'
if Doorkeeper::Application.count.zero?
  client_credentials = Rails.application.credentials.storysprout
  preset_credentials = if client_credentials.present?
                         {
                           uid: client_credentials.client_id,
                           secret: client_credentials.client_secret
                         }
                       else
                         {}
                       end
  Doorkeeper::Application.create(name: 'StorySprout', scopes: 'read write', **preset_credentials)

  puts 'Doorkeeper Applications created'
end

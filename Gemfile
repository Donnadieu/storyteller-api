# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.6'

gem 'pg', '~> 1.1' # Use postgresql as the database for Active Record
gem 'sqlite3' # Use sqlite3 as the database for Active Record

gem 'puma', '~> 5.0' # Use the Puma web server [https://github.com/puma/puma]

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'doorkeeper', '~> 5.6'
gem 'doorkeeper-jwt'
gem 'googleauth' # Google Auth Library for Ruby
gem 'rack-cors'
gem 'ruby-openai'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'climate_control'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'shoulda-matchers'
  gem 'strong_migrations'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # TODO: Keeping this gem out of production for now while we're still
  #   exploring the spike to use GCP cloud logging (vs. a cloud logging service)
  gem 'stackdriver', '~> 0.21'

  # Better Stack Rails integration
  gem 'logtail-rails'
end

group :test do
  gem 'database_cleaner-active_record'
end

gem 'apple_id', '~> 1.6'

gem 'flipper', '~> 0.28.3'
gem 'flipper-active_record', '~> 0.28.3'
gem 'flipper-api', '~> 0.28.3'
gem 'flipper-ui', '~> 0.28.3'

gem 'amazing_print'

gem 'rails_semantic_logger'

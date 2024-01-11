# frozen_string_literal: true

# Review docs at https://guides.rubyonrails.org/i18n.html

# Additional location(s) the I18n library should search for translation files
I18n.load_path += Dir[Rails.root.join('lib', 'locales', '**', '*.{rb,yml}')]

# Permitted locales available for the application
I18n.available_locales = [:en]

# Set default locale to something other than :en
I18n.default_locale = :en

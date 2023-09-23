# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors#rack-configuration

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Regex test: https://regex101.com/r/oqv0X5/1
    origins 'localhost:3006',
            '127.0.0.1:3006',
            'https://storyteller-ui.vercel.app',
            'https://storysprout.ngrok.app',
            /\Ahttps?:\/\/(?:[a-zA-Z0-9-]+\.)?storysprout\.app\z/
    resource "*",
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end

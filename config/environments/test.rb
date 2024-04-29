# frozen_string_literal: true

Rails.application.configure do
  config.load_defaults 7.0
  config.cache_classes = true
  config.eager_load = false
  config.public_file_server.enabled = true
  config.cache_control = 'public, max-age=3600'
  config.consider_all_requests_local = true
end

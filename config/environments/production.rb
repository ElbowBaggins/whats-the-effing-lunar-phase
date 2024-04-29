# frozen_string_literal: true

Rails.application.configure do
  config.load_defaults 7.0
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = true
  config.log_level = :debug
  config.log_formatter = ::Logger::Formatter.new
end

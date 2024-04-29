# frozen_string_literal: true

Rails.application.configure do
  config.load_defaults 7.0
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.assets.debug = true
  config.assets.js_compressor = :uglifier
end

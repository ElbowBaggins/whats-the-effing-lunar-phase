# frozen_string_literal: true

require File.expand_path('boot', __dir__ || '')

require 'active_model/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module WhatTheFuckIsTheLunarPhase
  class Application < Rails::Application
  end
end

# frozen_string_literal: true

# This is a application config file
require_relative 'boot'

require 'rails/all'
require 'dotenv/rails-now'
Dotenv::Railtie.load

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Login
  # The Login::Application class is the main application class for the Login
  # application. It inherits from the Rails::Application class and provides
  # configuration for the application, engines, and railties.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.time_zone = 'Asia/Kolkata'
    config.active_record.default_timezone = :local
    config.load_defaults 6.1
    config.elasticsearch = YAML.load_file(Rails.root.join('config', 'elasticsearch.yml'))[Rails.env].symbolize_keys

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

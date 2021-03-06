require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Amelia
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    # use sidekiq as jobs adapter
    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths += Dir[Rails.root.join('app', 'services', '{**/}')]
    config.autoload_paths += Dir[Rails.root.join('app', 'decorators', '{**/}')]
    config.autoload_paths += Dir["#{config.root}/lib/external_apis/**/"]

    config.generators do |generator|
      generator.fixture_replacement :factory_girl
      generator.factory_girl dir: 'spec/factories'
    end
  end
end
ENV['VISION_KEYFILE'] = "#{Rails.root}/config/credentials/video-webmaster-project-e8cdb47977ea.json"

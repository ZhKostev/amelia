require 'vcr'
require 'pry'
require 'webmock'
require 'simplecov'
require 'factory_girl'
require 'dotenv'
require 'mock_redis'

Dotenv.load('../.env.test') #load ENV variables
Dir[Dir.pwd + '/spec/support/**/*.rb'].each { |f| require f }
Dir[Dir.pwd + '/spec/shared_examples/**/*.rb'].each { |f| require f }

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  config.include InstagramSessionTest, type: :controller
end

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock, :faraday
end

if ENV["COVERAGE"]
  SimpleCov.start do
    add_filter '/spec/'

    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Helpers', 'app/helpers'
    add_group 'Services', 'app/services'
    add_group 'Middleware', 'app/middleware'
    add_group 'Lib', 'lib'
  end
end

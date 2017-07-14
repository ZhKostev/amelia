source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.2'
gem 'pg', '~> 0.18' # Use postgresql as the database for Active Record
gem 'puma', '~> 3.7' # Use Puma as the app server
gem 'turbolinks', '~> 5' # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'coffee-rails', '~> 4.2'
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'execjs' #fix 'Could not find a JavaScript runtime. See https://github.com/sstephenson/execjs'
gem 'therubyracer' #fix 'Could not find a JavaScript runtime. See https://github.com/sstephenson/execjs'
gem 'sidekiq' #Background jobs for Rails
gem 'sinatra', require: false # support sinatra apps. Required by sidekiq monitoring
gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'redis', '~> 3.0' #Use Redis adapter to run Action Cable in production

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw] # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "letter_opener" #do not send emails in dev env
end

group :development do
  gem 'rubycritic' # code style guidelines
  gem 'web-console', '>= 3.3.0'  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rspec-rails' # RSpec for testing
end

group :test do
  gem 'simplecov' #generate code coverage
  gem 'vcr' # stub external requests
  gem 'capybara' # for integration test
  gem 'factory_girl_rails' #generate models for tests
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

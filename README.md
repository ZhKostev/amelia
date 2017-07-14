#  project

## Developement env

#### Project code style guide

Project code quality is controlled by rubycritic (uses reek under the hood). 
Please run `rubycritic` in project root directory it will generate html report "tmp/rubycritic/overview.html"


## Test env

Main test tools: Rspec, Capybara, FactoryGirl, VCR, SimpleCov.

* Please stub external requests with VCR. Examples here https://github.com/vcr/vcr 


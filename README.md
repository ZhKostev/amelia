#  Project "Amelia"

Main purpose of this project is to try latest Rails with action cable and use this app as demo for interviews. This app is an example of
Rails 5 application that intergrates with Instagram API, fetches images from Instagram, parses these images and provides simple
analytics to site visitors. This is test app and not production ready (missing some validations etc).

Key "parts":
* Instagram API integration (oauth2 + tags endpoints)
* Image parsing via Google Cloud Vision
* Rails 5 with action cable
* Ruby 2.4
* Code quality is controlled by rubycritic
* Tests via rspec, capybara, FactoryGirl, VCR, faker and check coverage with SimpleCov

## Developement env

#### Project code style guide

Project code quality is controlled by rubycritic (uses reek under the hood). 
Please run `rubycritic` in project root directory it will generate html report "tmp/rubycritic/overview.html"


## Test env

Main test tools: Rspec, Capybara, FactoryGirl, VCR, SimpleCov, Faker.

* Please stub external requests with VCR. Examples here https://github.com/vcr/vcr 

#### To run test suit with coverage please run

`COVERAGE=1 rspec spec/`
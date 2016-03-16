$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'napster'
require 'faker'
require 'capybara/rspec'
require 'capybara/poltergeist'

require 'config_loader'

Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
Capybara.app_host = Napster::Request::HOST_URL

Capybara.register_driver :poltergeist do |app|
  driver_options = { phantomjs: 'phantomjs' }
  Capybara::Poltergeist::Driver.new(app, driver_options)
end

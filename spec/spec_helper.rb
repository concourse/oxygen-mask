require 'capybara/rspec'
require 'selenium/webdriver'
require 'fly'
require 'dash'

ATC_URL = ENV.fetch('ATC_URL', 'https://wings.concourse.ci').freeze
TEAM_NAME = ENV.fetch('TEAM_NAME', 'monitoring').freeze
PIPELINE_NAME = ENV.fetch('PIPELINE_NAME', 'monitoring').freeze
USERNAME = ENV.fetch('USERNAME', '').freeze
PASSWORD = ENV.fetch('PASSWORD', '').freeze

RSpec.configure do |config|
  include Fly
  config.include Dash
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu no-sandbox] }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

Capybara.default_driver = :headless_chrome
Capybara.javascript_driver = :headless_chrome

Capybara.save_path = '/tmp'

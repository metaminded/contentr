ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'factory_girl'
require 'database_cleaner'

FactoryGirl.find_definitions

Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {js_errors: true})
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
require File.expand_path("../support/features/session_helpers.rb",  __FILE__)


RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.order = "random"

  # config.include Contentr::Engine.routes.url_helpers
  config.include Features::SessionHelpers, type: :feature

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:each, type: :feature) do
    Contentr::User.instance_variable_set(:@_contentr_current, nil)
  end

end

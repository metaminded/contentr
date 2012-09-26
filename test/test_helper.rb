#
# Basic setup
#
ENV["RAILS_ENV"] = "test"
require File.expand_path("../../spec/dummy/config/environment.rb",  __FILE__)
ENV['RAILS_ENV'] = 'test'
# require File.expand_path('../../spec/config/environment', __FILE__)
require "rails/test_help"
require 'capybara/rails'

#
# Require ruby files in support dir.
#
Dir[File.expand_path('test/support/*.rb')].each { |file| require file }

#
# Setup Rails
#
#Rails.application.default_url_options[:host] = 'ttpro.dev'

#
# Setup test database
#
#DatabaseCleaner.strategy = :truncation
#Capybara.javascript_driver = :webkit
# class MiniTest::Spec
#   before do
#     DatabaseCleaner.clean
#     Capybara.reset_sessions!
#     Warden.test_reset!
#   end
# end



#
# Setup turn
#
# Turn.config do |c|
#   c.format  = :pretty
#   c.natural = true
# end

__END__


Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

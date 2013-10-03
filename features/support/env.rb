ENV["RAILS_ENV"] = "test"
ENV["RAILS_ROOT"] = File.expand_path("../../../test/dummy", __FILE__)

require "cucumber/rails"
require "selenium/webdriver"
require "factory_girl"
require "ffaker"

ActionController::Base.allow_rescue = false

Capybara.default_driver   = :selenium
Capybara.default_selector = :css

Cucumber::Rails::World.use_transactional_fixtures = false
DatabaseCleaner.strategy  = :truncation
  
Dir["#{File.expand_path("../../../", __FILE__)}/test/support/**/*.rb"].each { |f| require f }

World(HelperMethods)
World(FactoryGirl::Syntax::Methods)

# ensures spree preferencs are reset before each test
Before do
  Spree::Config.instance_variable_set("@configuration", nil)
  Spree::Config[:track_inventory_levels] = true
end

ENV["RAILS_ENV"] = "test"
ENV["RAILS_ROOT"] = File.expand_path("../../../test/dummy", __FILE__)

require 'spork'
 
Spork.prefork do
  require 'cucumber/rails'
  require 'factory_girl'
  
  I18n.reload!
  
  ActionController::Base.allow_rescue = false
  
  Capybara.default_driver   = :selenium
  Capybara.default_selector = :css
  
  Cucumber::Rails::World.use_transactional_fixtures
  DatabaseCleaner.strategy  = :transaction
  
  Spree::Config.set(:random => rand(1000))
end
 
Spork.each_run do

  Dir["#{File.expand_path("../../../", __FILE__)}/test/support/**/*.rb"].each { |f| require f }
  World(HelperMethods)

end

# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
require 'spork'

Spork.prefork do
  
  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
  require "rails/test_help"
  require "shoulda"
  require "factory_girl"
  require "sqlite3"
  require "faker"
  
  # Run any available migration if needed
  ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)
end

Spork.each_run do

  #load File.expand_path("../../features/support/factories.rb", __FILE__)
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }


end

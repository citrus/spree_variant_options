# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
  
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "shoulda"
require "factory_girl"
require "sqlite3"
begin; require "turn"; rescue LoadError; end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

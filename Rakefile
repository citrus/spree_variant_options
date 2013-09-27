# encoding: UTF-8
require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty}
end

task :default => [ :test, :cucumber ]

require 'spree/testing_support/extension_rake'
desc 'Generates a dummy app for testing'
task :test_app do
  ENV['LIB_NAME'] = 'spree_variant_options'
  ENV['DUMMY_PATH'] = File.expand_path("../test/dummy", __FILE__)
  Rake::Task['extension:test_app'].invoke
end

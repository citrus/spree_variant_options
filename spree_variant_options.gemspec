# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spree_variant_options/version"

Gem::Specification.new do |s|
  s.name        = "spree_variant_options"
  s.version     = SpreeVariantOptions::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Spencer Steffen"]
  s.email       = ["spencer@citrusme.com"]
  s.homepage    = "https://github.com/citrus/spree_variant_options"
  s.summary     = %q{Spree Variant Options is a simple spree extension that replaces the radio-button variant selection with groups of option types and values.}
  s.description = %q{Spree Variant Options is a simple spree extension that replaces the radio-button variant selection with groups of option types and values. Please see the documentation for more details.}

  s.require_path = 'lib'
  s.requirements << 'none'

  # Runtime
  s.add_dependency('spree_core', '~> 2.0.4')

  # Development
  s.add_development_dependency('shoulda',          '~> 3.0')
  s.add_development_dependency('factory_girl',     '~> 4.2')
  s.add_development_dependency('cucumber-rails',   '~> 1.2')
  s.add_development_dependency('database_cleaner', '~> 0.6')
  s.add_development_dependency('sqlite3',          '~> 1.3')
  s.add_development_dependency('capybara')
  s.add_development_dependency('selenium-webdriver')
  s.add_development_dependency('coffee-script')
  s.add_development_dependency('launchy')
  s.add_development_dependency('therubyracer')
  s.add_development_dependency('database_cleaner', '< 1.1.0')

end

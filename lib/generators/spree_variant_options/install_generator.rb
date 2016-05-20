module SpreeVariantOptions
  module Generators
    class InstallGenerator < Rails::Generators::Base

      desc "Installs required migrations for spree_essentials"

      def copy_migrations
        rake "spree_variant_options:install:migrations"
      end

      def add_javascripts
        append_file "vendor/assets/javascripts/spree/frontend/all.js", "//= require spree_variant_options\n"
      end

      def add_stylesheets
        inject_into_file "vendor/assets/stylesheets/spree/frontend/all.css", "*= require spree_variant_options\n", before: /\*\//, verbose: true
      end

      def add_to_assest_precompile
        append_file "config/initializers/assets.rb", "Rails.application.config.assets.precompile += %w( frontend/variant_options.js )\n"
      end
    end
  end
end

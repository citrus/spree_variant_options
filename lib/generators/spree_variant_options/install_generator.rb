module SpreeVariantOptions
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      desc "Installs required migrations for spree_essentials"
      
      def copy_migrations
        rake "spree_variant_options:install:migrations"
      end
      
      def add_javascripts
        append_file "app/assets/javascripts/store/all.js", "//= require store/product_variant_options\n"
        append_file "app/assets/javascripts/store/all.js", "//= require store/variant_options\n"
      end

      def add_stylesheets
        inject_into_file "app/assets/stylesheets/store/all.css", "*= require store/variant_options\n", :before => /\*\//, :verbose => true
      end

    end
  end
end

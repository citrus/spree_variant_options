require 'spree_core'
require 'spree_sample' unless Rails.env == 'production'

# This class is defined in spree_auth.. we'll define
unless defined? Spree::User::DestroyWithOrdersError
  module Spree
    class User < ActiveRecord::Base
      class DestroyWithOrdersError < StandardError; end
    end
  end
end

module SpreeVariantOptions

  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    config.to_prepare do
      #loads application's model / class decorators
      Dir.glob File.expand_path("../../app/**/*_decorator.rb", __FILE__) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      #loads application's deface view overrides
      Dir.glob File.expand_path("../../app/overrides/*.rb", __FILE__) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
    end
    
  end
  
end

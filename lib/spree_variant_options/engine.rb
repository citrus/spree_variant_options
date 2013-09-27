module SpreeVariantOptions
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name "spree_variant_options"

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    initializer "spree_variant_options.environment", :before => :load_config_initializers, :after => "spree.environment" do |app|
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/models/spree/app_configuration/*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
      app.config.spree.add_class('variant_preferences')
      app.config.spree.variant_preferences = SpreeVariantOptions::VariantConfiguration.new
      SpreeVariantOptions::VariantConfig = app.config.spree.variant_preferences
    end
  end
end

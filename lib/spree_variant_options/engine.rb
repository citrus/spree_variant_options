module SpreeVariantOptions
  class Engine < Rails::Engine
    isolate_namespace SpreeVariantOptions
    engine_name "spree_variant_options"

    config.to_prepare do
      #loads application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
    end

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

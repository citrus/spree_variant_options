module SpreeVariantOptions
  class VariantConfiguration < Spree::Preferences::Configuration
    preference :allow_select_outofstock, :boolean, :default => false
  end
end

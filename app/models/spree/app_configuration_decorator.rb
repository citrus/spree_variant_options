Spree::AppConfiguration.class_eval do
  preference :allow_select_outofstock, :boolean, :default => false
end
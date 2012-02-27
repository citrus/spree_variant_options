rake "spree:install:migrations"

insert_into_file File.join('config', 'routes.rb'), :after => "Application.routes.draw do\n" do
  "  # Mount Spree's routes\n  mount Spree::Core::Engine, :at => '/'\n"
end

# Fix uninitialized constant Spree::User::DestroyWithOrdersError 
template "spree_user_error_fix.rb", "config/initializers/spree_user_error_fix.rb"

# remove all stylesheets except core
%w(admin store).each do |ns|
  template "#{ns}/all.js",  "app/assets/javascripts/#{ns}/all.js",  :force => true
  template "#{ns}/all.css", "app/assets/stylesheets/#{ns}/all.css", :force => true
end

# Fix sass load error by using the converted css file
template "store/screen.css", "app/assets/stylesheets/store/screen.css"

run "rails g spree_variant_options:install"

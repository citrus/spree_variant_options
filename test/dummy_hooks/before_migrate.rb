# install spree & spree_sample
rake "spree_core:install spree_sample:install"

# since spree auth isn't installed
create_file "app/views/shared/_login_bar.html.erb", ""

# remove the default product.js
remove_file "public/javascripts/product.js"

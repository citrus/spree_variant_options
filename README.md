# Spree Variant Options


Spree Variant Options is a very simple spree extension that replaces the radio-button variant selection with groups of option types and values. To get a better idea let's let a few images do the explaining.


#### When no selection has been made:
![Spree Variant Options - No selection](http://spree-docs.s3.amazonaws.com/spree_variant_options/v0.3.1/1.jpg)

#### After "Large" is selected, "Large Blue" is out of stock:

![Spree Variant Options - Option Type/Value selected](http://spree-docs.s3.amazonaws.com/spree_variant_options/v0.3.1/2.jpg)

#### And after "Green" is selected:
![Spree Variant Options - Variant Selcted](http://spree-docs.s3.amazonaws.com/spree_variant_options/v0.3.1/3.jpg)

To see it in action, follow the steps for "Demo" below.


------------------------------------------------------------------------------
Installation
------------------------------------------------------------------------------

If you don't already have an existing Spree site, [click here](https://gist.github.com/946719) then come back later... You can also read the Spree docs [here](http://spreecommerce.com/documentation/getting_started.html)...

To install Spree Variant Options, just add the following to your Gemfile:

```ruby
gem 'spree_variant_options', github: 'vinsol-spree-contrib/spree_variant_options', branch: '3-1-stable'
```

Now, bundle up with:

```bash
bundle
```

Next, run the install generator to copy the necessary migration to your project and migrate your database:

```bash
rails g spree_variant_options:install
rake db:migrate
```

------------------------------------------------------------------------------
Configuration Options
------------------------------------------------------------------------------

Spree Variant Options comes with some handy options:

- allow_select_outofstock (default : false)
  When using extension like ([spree_wishlist](https://github.com/spree/spree_wishlist)), you might want to allow your customer to add out of stock product by selecting out of stock variant options :
  ```erb
    <%= form_for Spree::WishedProduct.new, :html => {:"data-form-type" => "variant"} do |f| %>
      <%= f.hidden_field :variant_id, :value => @product.master.id %>
      <button type="submit" class="medium blue awesome">
        <%= t(:add_to_wishlist) %>
      </button>
    <% end %>
  ```
  By setting allow_select_outofstock to true, when an user selects variant options it will automatically update any form's input variant_id with an data-form-type="variant" attribute.

- default_instock (default: false)
  If this is option is set to true, it will automatically preselect in-stock variant options.

These configuration options can be set in a config/initializers/spree_variant_options.rb file for example :
```ruby
SpreeVariantOptions::VariantConfig.allow_select_outofstock = true
SpreeVariantOptions::VariantConfig.default_instock = true
```

### Storage options
Like in spree core there is support for storage of images on S3.
Storage on S3 is enabled with the same configuration as in spree core.

Example: config/initializers/spree.rb

```ruby
Spree.config do |config|
  config.use_s3 = true
  config.s3_bucket = <bucket_name>
  config.s3_access_key = <aws_access_key>
  config.s3_secret = <aws_secret_key>
end
```

------------------------------------------------------------------------------
Testing
------------------------------------------------------------------------------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```bash
bundle install
bundle exec rake test_app
bundle exec rspec spec
```


------------------------------------------------------------------------------
Contributors
------------------------------------------------------------------------------

* Spencer Steffen ([@citrus](https://github.com/citrus))
* Stéphane Bounmy ([@sbounmy](https://github.com/sbounmy))
* Dan Morin ([@danmorin](https://github.com/danmorin))
* Richard Brown ([@rbrown](https://github.com/rbrown))
* [@baracek](https://github.com/baracek)

If you'd like to help out feel free to fork and send me pull requests!


------------------------------------------------------------------------------
License
------------------------------------------------------------------------------

Copyright (c) 2011 - 2012 Spencer Steffen and Citrus, released under the New BSD License All rights reserved.

Spree Variant Options
=====================

Spree Variant Options is a very simple spree extension that replaces the radio-button variant selection with groups of option types and values. To get a better idea let's let a few images do the explaining.


#### When no selection has been made:
![Spree Variant Options - No selection](http://spree-docs.s3.amazonaws.com/spree_variant_options/1.jpg)

#### After "Medium" is selected, "Medium Blue" is out of stock:

![Spree Variant Options - Option Type/Value selected](http://spree-docs.s3.amazonaws.com/spree_variant_options/2.jpg)

#### And after "Green" is selected:
![Spree Variant Options - Variant Selcted](http://spree-docs.s3.amazonaws.com/spree_variant_options/3.jpg)

To see it in action, follow the steps for "Demo" below.


Installation
------------

If you don't already have an existing Spree site, [click here](https://gist.github.com/946719) then come back later... You can also read the Spree docs [here](http://spreecommerce.com/documentation/getting_started.html)...

To install Spree Variant Options, just add the following to your Gemfile:

    gem 'spree_variant_options', '0.1.1'
  

Now, bundle up with:

    bundle


Spree Variant Options doesn't require any rake tasks or generators, but you'll need include `app/views/products/_variant_options.html.erb` in your product show view.

If you don't have a custom version of `_cart_form.html.erb` in your application, then don't worry about a thing, spree_variant_options will include the partial for you. Otherwise, just replace the entire `<% if @product.has_variants? %>` block with:

    <%= render 'variant_options' %>


To tie spree_variant_options in with your product photos just delete your local copy of `product.js` or copy spree_variant_options' `product.js` to your local `public/javascripts` directory.



Versions
--------

Spree Variant Options works on Spree 0.30.x and above... Please let me know if you run into any issues.


Testing
-------

Clone this repo to where you develop, bundle up, then run `dummier' to get the show started:

    git clone git://github.com/citrus/spree_variant_options.git
    cd spree_variant_options
    bundle install
    bundle exec dummier


This will generate a fresh rails app in test/dummy, install spree & spree_variant_options, then migrate the test database. Sweet.


### Spork + Cucumber

To run the cucumber features, boot spork like this:

    bundle exec spork

Then, in another window, run:

    cucumber --drb


### Spork + Test::Unit
    
If you want to run shoulda tests, start spork with:

    bundle exec spork TestUnit
    #or 
    bundle exec spork t
        
In another window, run all tests:

    testdrb test/**/*_test.rb
    
Or just a specific test:

    testdrb test/unit/supplier_test.rb
  

### No Spork

If you don't want to spork, just use rake:

    # cucumber/capybara
    rake cucumber
    
    # test/unit
    rake test
    
    # both
    rake 
  
POW!


Demo
----

You can easily use the test/dummy app as a demo of spree_variant_options. Just `cd` to where you develop and run:

    git clone git://github.com/citrus/spree_variant_options.git
    cd spree_variant_options
    mv lib/dummy_hooks/after_migrate.rb.sample lib/dummy_hooks/after_migrate.rb
    bundle install
    bundle exec dummier
    cd test/dummy
    rails s
    

Contributors
------------

So far it's just me; Spencer Steffen. 

If you'd like to help out feel free to fork and send me pull requests!


License
-------

Copyright (c) 2011 Spencer Steffen and Citrus, released under the New BSD License All rights reserved.

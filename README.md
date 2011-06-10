Spree Variant Options
=====================

... is going to be pretty awesome.



Installation
------------

Don't do this quite yet...


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

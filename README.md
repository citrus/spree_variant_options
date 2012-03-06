# Spree Variant Options [![Build Status](https://secure.travis-ci.org/citrus/spree_variant_options.png)](http://travis-ci.org/citrus/spree_variant_options)


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
gem 'spree_variant_options', '0.4.1'
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
Versions
------------------------------------------------------------------------------

Spree Variant Options is compatible with Spree 0.30.x through 1.0.x. Please reference `Versionfile` for more details.


------------------------------------------------------------------------------
Testing
------------------------------------------------------------------------------

Clone this repo to where you develop, bundle up, then run `dummier' to get the show started:

```bash
git clone git://github.com/citrus/spree_variant_options.git
cd spree_variant_options
bundle install
bundle exec dummier

# cucumber/capybara
bundle exec rake cucumber

# test/unit
bundle exec rake test

# both
bundle exec rake 
```

POW!


------------------------------------------------------------------------------
Demo
------------------------------------------------------------------------------

You can easily use the test/dummy app as a demo of spree_variant_options. Just `cd` to where you develop and run:

```bash
git clone git://github.com/citrus/spree_variant_options.git
cd spree_variant_options
cp test/dummy_hooks/after_migrate.rb.sample test/dummy_hooks/after_migrate.rb
bundle install
bundle exec dummier
cd test/dummy
rails s
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

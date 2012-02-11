Deface::Override.new(:virtual_path => "spree/products/_cart_form",
                     :name         => "spree_variant_options",
                     :replace      => "#product-variants",
                     :partial      => "spree/products/variant_options",
                     :disabled     => false)

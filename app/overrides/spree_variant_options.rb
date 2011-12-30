Deface::Override.new(:virtual_path => "products/_cart_form",
                     :name         => "spree_variant_options",
                     :replace      => "#product-variants",
                     :partial      => "products/variant_options",
                     :disabled     => false)

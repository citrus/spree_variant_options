Deface::Override.new(
  virtual_path: "spree/products/show",
  name:         "variants_present",
  insert_after:  "h1.product-title",
  text: %q{
    <%= hidden_field_tag 'variant_present', @product.variants.present? %>
  }
)


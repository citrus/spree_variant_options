Deface::Override.new(
  virtual_path: "spree/products/_thumbnails",
  name:         "add_noimage_to_thumbnails",
  insert_bottom:  "ul#product-thumbnails",
  partial: 'spree/products/noimage'
)

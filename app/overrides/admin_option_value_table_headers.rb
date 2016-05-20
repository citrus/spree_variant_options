Deface::Override.new(
  virtual_path: "spree/admin/option_types/edit",
  name:         "admin_option_value_table_headers",
  replace:      "thead[data-hook=option_header]",
  partial:      "spree/admin/option_values/table_header",
  disabled:     false
)

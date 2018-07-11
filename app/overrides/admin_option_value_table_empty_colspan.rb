Deface::Override.new(
  virtual_path:   "spree/admin/option_types/edit",
  name:           "admin_option_value_table_empty_colspan",
  set_attributes: "tr[data-hook=option_none] td",
  attributes:     { colspan:  5 },
  disabled:       false
)

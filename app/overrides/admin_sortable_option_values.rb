Deface::Override.new(
  virtual_path:   "spree/admin/option_types/edit",
  name:           "admin_sortable_option_values",
  set_attributes: "table.index",
  disabled:       false,
  attributes:     {
   "class"              => "index sortable",
   "data-sortable-link" => "/admin/option_values/update_positions"
  }
)

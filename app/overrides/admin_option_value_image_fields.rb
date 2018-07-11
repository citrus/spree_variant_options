Deface::Override.new(
  virtual_path: "spree/admin/option_types/_option_value_fields",
  name:         "admin_option_value_image_fields",
  insert_after: "td.presentation",
  text: "
    <td class='image-preview'>
    <%= image_tag f.object.image.url(:small) if f.object.has_image? %>
  </td>
  <td class='image'><%= f.file_field :image %></td>
  "
)

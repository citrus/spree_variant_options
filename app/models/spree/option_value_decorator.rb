Spree::OptionValue.class_eval do

  has_attached_file :image,
    styles:         { small: '40x30#', large: '140x110#' },
    default_style:  :small,
    url:            "/spree/option_values/:id/:style/:basename.:extension",
    path:           ":rails_root/public/spree/option_values/:id/:style/:basename.:extension"

  validates_attachment :image, content_type: { content_type: /\Aimage\/.*\Z/ },
    size: { in: 0..1.megabytes }

  def has_image?
    !!(image_file_name && !image_file_name.empty?)
  end
end

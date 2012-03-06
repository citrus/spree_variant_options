Spree::OptionValue.class_eval do

  default_scope order("#{quoted_table_name}.position")

  has_attached_file :image,
    :styles        => { :small => '40x30#', :large => '140x110#' },
    :default_style => :small,
    :url           => "/spree/option_values/:id/:style/:basename.:extension",
    :path          => ":rails_root/public/spree/option_values/:id/:style/:basename.:extension"

  def has_image?
    image_file_name && !image_file_name.empty?
  end

  scope :for_product, lambda { |product| select("DISTINCT #{table_name}.*").where("spree_option_values_variants.variant_id IN (?)", product.variant_ids).joins(:variants)
  }
end

OptionValue.class_eval do

  default_scope order("#{quoted_table_name}.position")
  
  if defined?(SpreeHeroku)
    has_attached_file :image, 
      :styles => { :small => '40x30#', :large => '140x110#' },
      :default_style => :small,
      :path => "assets/option_values/:id/:style/:basename.:extension",
      :storage => "s3",
      :s3_credentials => "#{Rails.root}/config/s3.yml"
  else
    has_attached_file :image, 
      :styles => { :small => '40x30#', :large => '140x110#' },
      :default_style => :small,
      :url => "/assets/option_values/:id/:style/:basename.:extension",
      :path => ":rails_root/public/assets/option_values/:id/:style/:basename.:extension"
  end

  def has_image?
    image_file_name && !image_file_name.empty?
  end

  scope :for_product, lambda { |product| select("DISTINCT #{table_name}.*").where("option_values_variants.variant_id IN (?)", product.variant_ids).joins(:variants) }

end

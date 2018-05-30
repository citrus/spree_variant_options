Spree::Variant.class_eval do
  validate :uniqueness_of_option_values

  def uniqueness_of_option_values
    product.variants.each do |v|
      variant_option_values = v.option_values.ids
      this_option_values = option_values.collect(&:id)
      matches_with_another_variant = (variant_option_values.length == this_option_values.length) && (variant_option_values - this_option_values).empty?
      if  !option_values.empty? &&  !(persisted? && v.id == id) && matches_with_another_variant
        errors.add(:base, :already_created)
      end
    end
  end
end


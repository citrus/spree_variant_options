Spree::Variant.class_eval do
  validate :uniqueness_of_option_values, unless: lambda {  option_values.empty? }

  def uniqueness_of_option_values

    product.variants.each do |v|
      if v.id != id
        variant_option_values = v.option_values.ids
        this_option_values = option_values.collect(&:id)
        matches_with_another_variant = this_option_values.to_set == variant_option_values.to_set
        if  matches_with_another_variant
          errors.add(:base, Spree.t(:already_created))
        end
      end
    end
  end
end

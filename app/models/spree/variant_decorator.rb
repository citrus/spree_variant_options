Spree::Variant.class_eval do
  validate :uniqueness_of_option_values,if: -> {!is_master}

  def uniqueness_of_option_values
    product.variants.find_each do |variant|
      if variant.option_values.pluck('name').sort == option_values.collect(&:name).sort
        errors.add(:base, :already_created)
      end
    end
  end
end

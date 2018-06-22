Spree::Variant.class_eval do
  validate :uniqueness_of_option_values, unless: lambda {  option_values.empty? }

  def uniqueness_of_option_values
    if product.variants.where.not(id: self.id).includes(:option_values).map(&:option_value_ids).include? option_values.map(&:id)
      errors.add(:base, Spree.t(:already_created))
    end
  end
end

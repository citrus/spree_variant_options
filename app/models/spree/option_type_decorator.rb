Spree::OptionType.class_eval do
  before_destroy :check_for_associated_products, prepend: true

  private
    def check_for_associated_products
      if products.present?
        errors.add(:base, Spree.t(:products_associated))
        throw :abort
      end
    end
end

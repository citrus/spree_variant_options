Spree::Product.class_eval do

  has_many :option_values, through: :variants

  def ordered_option_types
    option_types.order(:position)
  end

  def variants_option_value_details
    variants.includes(option_values: :option_type).collect do |variant|
      details = get_initial_detail(variant)

      variant.option_values.each do |option_value|
        details[:option_types][option_value.option_type.id] = option_value.id
      end

      details
    end
  end

  private
    def get_initial_detail(variant)
      {
        in_stock: variant.can_supply?,
        variant_id: variant.id,
        variant_price: variant.price_in(Spree::Config[:currency]).money,
        option_types: {},
      }
    end
end

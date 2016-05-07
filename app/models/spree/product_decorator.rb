Spree::Product.class_eval do

  has_many :option_values, -> { uniq }, through: :variants

  def grouped_option_values
    option_types.includes(:option_values).order(:position)
  end

  def variants_option_value_details
    variants.includes(option_values: :option_type).collect do |variant|
      details = {
        in_stock: variant.can_supply?,
        variant_id: variant.id,
        variant_price: variant.price_in(Spree::Config[:currency]).money,
        option_types: {},
      }
      variant.option_values.each do |option_value|
        details[:option_types][option_value.option_type.id] = option_value.id
      end
      details
    end
  end
end

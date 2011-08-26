Product.class_eval do

  include ActionView::Helpers::NumberHelper

  def option_values
    option_types.map { |i| i.option_values }.flatten.uniq
  end
  
  def grouped_option_values
    option_values.group_by(&:option_type)
  end

  def available_variant_options
    return @available_variant_options if @available_variant_options
    @available_variant_options = variants.includes(:option_values).map { |variant| 
      variant.option_values
    }.flatten.uniq
  end
  
  def variants_for_option_value(value)
    variants.includes(:option_values).select { |i| i.option_values.select { |j| j == value }.length == 1 }
  end
  
  def variant_options_hash  
    return @variant_options_hash if @variant_options_hash
    @variant_options_hash = Hash[grouped_option_values.map { |type, values| 
      [type.id.inspect, Hash[values.map { |value|     
        hsh = Hash[variants.includes(:option_values).select { |variant| 
          variant.option_values.select { |val| 
            val.id == value.id && val.option_type_id == type.id 
          }.length == 1 }.map { |v| [ v.id, v.variant_options_hash ] }]
        [value.id.inspect, hsh]
      }]]
    }]
  end
  
end

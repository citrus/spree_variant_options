Product.class_eval do

  include ActionView::Helpers::NumberHelper

  def option_values
    @_option_values ||= option_types.map { |i| i.option_values }.flatten.uniq
  end
  
  def grouped_option_values
    @_grouped_option_values ||= option_values.group_by(&:option_type)
  end

  def available_variant_options
    @_available_variant_options ||= variants.includes(:option_values).map { |variant| 
      variant.option_values
    }.flatten.uniq
  end
  
  def variants_for_option_value(value)    
    @_variant_option_values ||= variants.includes(:option_values).all
    @_variant_option_values.select { |i| i.option_values.select { |j| j == value }.length == 1 }
  end
  
  def variant_options_hash
    return @_variant_options_hash if @_variant_options_hash
    hsh = {}
    variants.includes(:option_values).each do |variant|
      variant.option_values.each do |ov|
        hsh[ov.option_type_id] ||= {}
        hsh[ov.option_type_id][ov.id] ||= {}
        hsh[ov.option_type_id][ov.id][variant.id] = variant.variant_options_hash
      end
    end
    @_variant_options_hash = hsh
  end
  
end

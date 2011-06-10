ProductsHelper.class_eval do

  def variant_options_hash  
    return unless @product
    Hash[@product.grouped_option_values.map{ |type, values| 
      [type.id.inspect, Hash[values.map{ |value|         
        [value.id.inspect, Hash[@variants.select{ |variant| 
          variant.option_values.select{ |val| 
            val.id == value.id && val.option_type_id == type.id 
          }.length == 1 }.map{ |v| [ v.id, v.count_on_hand ] }]
        ]
      }]]
    }].to_json.html_safe
  end
  
end

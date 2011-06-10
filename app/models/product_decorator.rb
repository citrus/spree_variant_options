Product.class_eval do

  def option_values
    vals = option_types.map{|i| i.option_values }.flatten.uniq
    puts vals
    vals
  end
  
  def grouped_option_values
    option_values.group_by(&:option_type)
  end

end

Variant.class_eval do

  def inspect
    %(<#{[sku, option_values.inspect].join(" - ")}>)
  end


end


OptionValue.class_eval do

  def inspect
    %(<#{[option_type_id, presentation].join(" - ")}>)
    #[:option_type_id].map{|i| send(i).inspect }.join("\t")
  end


end

Product.class_eval do

  def option_values
    vals = option_types.map{|i| i.option_values }.flatten.uniq
  end
  
  def grouped_option_values
    option_values.group_by(&:option_type)
  end

end

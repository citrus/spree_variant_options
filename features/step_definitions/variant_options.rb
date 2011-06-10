Given /^I have a product( with variants)?$/ do |has_variants|
  product = Factory.create(:product)
  return unless has_variants
  sizes = %w(Small Medium Large X-Large).map{|i| Factory.create(:option_value, :presentation => i) }
  colors = %w(Red Green Blue Yellow Purple Gray Black White).map{|i| Factory.create(:option_value, :presentation => i, :option_type => OptionType.find_by_name("color") || Factory.create(:option_type, :presentation => "Color")) }
  product.variants = sizes.map{|i| colors.map{|j| Factory.create(:variant, :option_values => [i, j]) }}.flatten
  product.save
end

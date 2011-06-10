Given /^I have a product( with variants)?$/ do |has_variants|
  @product = Factory.create(has_variants ? :product_with_variants : :product)
end

Then /^the source should contain the options hash$/ do
  assert source.include?("VariantOptions(#{@product.variant_options_hash.to_json})")
end

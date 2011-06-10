Given /^I have a product( with variants)?$/ do |has_variants|
  @product = Factory.create(has_variants ? :product_with_variants : :product)
end

Given /^the "([^"]*)" variant is out of stock$/ do |descriptor|
  flunk unless @product
  values = descriptor.split(" ")
  values.map! { |word| OptionValue.find_by_presentation(word) }
  variant = @product.variants.includes(:option_values).select{|i| i.option_value_ids.sort == values.map(&:id) }.first
  @variant = variant if variant.update_attributes(:count_on_hand => 0)
end

Then /^the source should contain the options hash$/ do
  assert source.include?("VariantOptions(#{@product.variant_options_hash.to_json})")
end

Then /^I should see (enabled|disabled)+ links for the ((?!option).*) option type$/ do |state, option_type|
  enabled = state == "enabled"
  option_type = case option_type
    when "first";  @product.option_types.first;
    when "second"; @product.option_types[1];
    when "last";   @product.option_types.last;
  end
  assert_seen option_type.presentation, :within => "#option_type_#{option_type.id} h3.variant-option-type"
  option_type.option_values.each do |value|
    rel = "#{option_type.id}-#{value.id}"
    link = find("#option_type_#{option_type.id} a[rel='#{option_type.id}-#{value.id}']")
    assert_not_nil link
    assert_equal value.presentation, link.text
    assert_equal "#", link.native.attribute('href').last
    assert_equal "option-value in-stock#{' enabled' if enabled}", link.native.attribute('class')
    assert_equal rel, link.native.attribute('rel') # obviously!
  end  
end

Then /^I should have a hidden input for the selected variant$/ do
  flunk unless @product
  field = find("input[type=hidden]#variant_id")
  assert_not_nil field
  assert_equal "products[#{@product.id}]", field.native.attribute("name")
  assert_equal "", field.native.attribute("value")
end

Then /^the add to cart button should be (enabled|disabled)?$/ do |state|
  enabled = state == "enabled"
  button = find("#cart-form button[type=submit]")
  assert_equal !enabled, button.native.attribute("disabled") == "true"
end

Then /^I should see an (out-of|in)-stock link for "([^"]*)"$/ do |state, button|
  in_stock = state == "in"
  buttons = button.split(", ")
  buttons.each do |button|
    link = find("a.option-value.#{in_stock ? 'in-stock' : 'out-of-stock'}")
    assert_not_nil link
    assert link.native.attribute("class").include?("enabled")
  end
end

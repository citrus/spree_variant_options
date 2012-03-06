#===============================
# Helpers

def variant_by_descriptor(descriptor)
  values = descriptor.split(" ")
  values.map! { |word| Spree::OptionValue.find_by_presentation(word) rescue nil }.compact!
  return if values.blank?
  @product.variants.includes(:option_values).select{|i| i.option_value_ids.sort == values.map(&:id) }.first
end

def random_image
  unless @sample_images
    dir = File.expand_path("../../../test/support/images/*", __FILE__)
    @sample_images = Dir[dir]
  end
  image = @sample_images.shuffle.first
  File.open(image)
end

#===============================
# Givens

Given /^I( don't)? allow backorders$/ do |dont|
  Spree::Config.instance_variable_set("@configuration", nil)
  Spree::Config.set(:allow_backorders => dont.nil?)
  assert_equal dont.nil?, !!Spree::Config[:allow_backorders]
end

Given /^I have a product( with variants)?( and images)?$/ do |has_variants, has_images|
  @product = Factory.create(has_variants ? :product_with_variants : :product)
  unless has_images.nil?
    @product.images.create(:attachment => random_image, :alt => @product.name)
    unless has_variants.nil?
      @product.variants.each do |v|
        v.images.create(:attachment => random_image, :alt => v.sku)
      end
    end   
  end
end

Given /^the first option type has an option value with image "([^"]*)"$/ do |source|
  flunk unless @product
  @product.option_types.first.option_values.first.update_attributes(:image => File.open(Rails.root.join("../support/images/#{source}")))
end

Then /^I should see image "([^"]*)" within the first option value$/ do |source|
  ot = @product.option_types.first
  ov = ot.option_values.first
  within ".variant-options a[rel='#{ot.id}-#{ov.id}']" do
    assert_match "/spree/option_values/#{ov.id}/small/#{source}", find("img").native.attribute("src")
  end
end

Given /^the "([^"]*)" variant is out of stock$/ do |descriptor|
  flunk unless @product
  @variant = variant_by_descriptor(descriptor)
  @variant.update_attributes(:count_on_hand => 0)
end

Given /^I have an? "([^"]*)" variant( for .*)?$/ do |descriptor, price|
  price = price ? price.gsub(/[^\d\.]/, '').to_f : 10.00
  values = descriptor.split(" ")
  flunk unless @product && values.length == @product.option_types.length
  @variant = variant_by_descriptor(descriptor)
  return @variant if @variant
  @product.option_type_ids.each_with_index do |otid, index|
    word = values[index]
    val = Spree::OptionValue.find_by_presentation(word) || Factory.create(:option_value, :option_type_id => otid, :presentation => word, :name => word.downcase) 
    values[index] = val
  end
  @variant = Factory.create(:variant, :product => @product, :option_values => values, :price => price)
  @product.reload
end


#===============================
# Whens

When /^I click the (current|first|last) clear button$/ do |parent|
  link = case parent
    when 'first'; find(".clear-index-0")
    when 'last'; find(".clear-index-#{@product.option_types.length - 1}")
    else find(".clear-button:last")
  end
  assert_not_nil link
  link.click
end

#===============================
# Thens

Then /^the source should contain the options hash$/ do
  assert source.include?("VariantOptions(#{@product.variant_options_hash.to_json}, #{Spree::Config[:allow_backorders]})")
end

Then /^I should see (enabled|disabled)+ links for the ((?!option).*) option type$/ do |state, option_type|
  enabled = state == "enabled"
  option_type = case option_type
    when "first";  @product.option_types.first;
    when "second"; @product.option_types[1];
    when "last";   @product.option_types.last;
  end
  assert_seen option_type.presentation, :within => "#spree_option_type_#{option_type.id} h6.variant-option-type"
  option_type.option_values.each do |value|
    rel = "#{option_type.id}-#{value.id}"
    link = find("#spree_option_type_#{option_type.id} a[rel='#{option_type.id}-#{value.id}']")
    assert_not_nil link
    assert_equal value.presentation, link.text
    assert_equal "#", link.native.attribute('href').last
    assert_equal "option-value #{enabled ? 'in-stock' : 'locked'}", link.native.attribute('class')
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
    link = find_link(button)
    assert_equal "option-value #{in_stock ? 'in' : 'out-of'}-stock", link.native.attribute("class")
    assert_not_nil link
  end
end

Then /^I should see "([^"]*)" selected within the (first|second|last) set of options$/ do |button, group|
  parent = case group
    when 'first';  '.variant-options.index-0'
    when 'second'; '.variant-options.index-1'
    when 'last';   ".variant-options.index-#{@product.option_values.length - 1}"
  end
  within parent do
    link = find_link(button)
    assert_not_nil link
    assert link.native.attribute("class").include?("selected")
  end
end

Then /^I should not see a selected option$/ do
  assert_raises Capybara::ElementNotFound do
    find(".option-value.selected")
  end
end

Then /^I should be on the cart page$/ do
  assert_equal cart_path, current_path
end

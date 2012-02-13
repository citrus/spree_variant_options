require 'uri'
require 'cgi'

def get_parent(parent)
  case parent.sub(/^the\s/, '')
    when "flash notice";  ".flash"
    when "first set of options";  "#spree_option_type_#{@product.option_types.first.id}"
    when "second set of options"; "#spree_option_type_#{@product.option_types[1].id}"
    when "variant images label";  "#product-thumbnails"
    when "price"; "#product-price .price"   
    else "[set-your-parent] #{parent}"
  end
end


# WTF OMG HAX! 
# Why aren't these url helpers present from the spree core?
# I've tried to include them in the env like so:
#
#  World(Spree::Core::Engine.routes.url_helpers)
#
# and like so:
#
#  World(Rails.application.routes.url_helpers)
#
# WTF?!?!?

def id_or_param(id)
  id = id.to_param if id.respond_to?(:to_param)
  id
end

def cart_path
  "/cart"
end

def product_path(id)
  "/products/#{id_or_param(id)}"
end

def edit_admin_option_type_path(id)
  "/admin/option_types/#{id_or_param(id)}/edit"
end



#========================================================================
# Givens

Given /^I'm on the ((?!page).*) page$/ do |path|
  path = "#{path.downcase.gsub(/\s/, '_')}_path".to_sym
  begin 
    visit send(path)
  rescue 
    puts "#{path} could not be found!"
  end
end

Given /^I'm on the ((?!page).*) page for (.*)$/ do |path, id|
  id = case id
    when "the first product"
      @product ||= Spree::Product.last
    when 'option type "Size"'
      @option_type = Spree::OptionType.find_by_presentation("Size")
    else id
  end
  path = "#{path.downcase.gsub(/\s/, '_')}_path".to_sym
  begin 
    visit send(path, id)
  rescue 
    puts "#{path}(#{id.to_param}) could not be found!"
  end
end


#========================================================================
# Actions

When /^(?:|I )press "([^"]*)"$/ do |button|
  # wtf button text spree!
  button = "#popup_ok" if button == "OK"
  click_button(button)
end

When /^I press "([^"]*)" in (.*)$/ do |button, parent|
  # wtf button text spree!
  button = "#popup_ok" if button == "OK"
  within get_parent(parent) do
    click_button(button)
  end
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )follow "([^"]*)" within (.*)$/ do |link, parent|
  within get_parent(parent) do
    click_link(link)
  end
end


When /^I wait for (\d+) seconds?$/ do |seconds|
  sleep seconds.to_f
end

When /^I confirm the popup message$/ do
  find_by_id("popup_ok").click
end






#========================================================================
# Assertions

Then /^I should see "([^"]*)"$/ do |text|
  assert page.has_content?(text)
end

Then /^I should see "([^"]*)" in (.*)$/ do |text, parent|
  within get_parent(parent) do
    assert page.has_content?(text)
  end
end

Then /^I should not see "([^"]*)"$/ do |text|
  assert_not page.has_content?(text)
end

Then /^I should not see "([^"]*)" in (.*)$/ do |text, parent|
  within get_parent(parent) do
    assert_not page.has_content?(text)
  end
end

Then /^"([^"]*)" should equal "([^"]*)"$/ do |field, value| 
  assert_equal value, find_field(field).value 
end 

Then /^"([^"]*)" should have "([^"]*)" selected$/ do |field, value| 
  field = find_field(field)
  has_match = field.text =~ /#{value}/
  has_match = field.value =~ /#{value}/ unless has_match
  assert has_match
end 


#========================================================================
# Forms

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )fill in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

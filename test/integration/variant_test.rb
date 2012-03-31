require 'test_helper'

class ProductTest < ActionDispatch::IntegrationTest

  setup do
    @product = Factory(:product)
    @size = Factory(:option_type)
    @color = Factory(:option_type, :name => "Color")
    @s = Factory(:option_value, :presentation => "S", :option_type => @size)
    @m = Factory(:option_value, :presentation => "M", :option_type => @size)
    @red = Factory(:option_value, :name => "Color", :presentation => "Red", :option_type => @color)
    @green = Factory(:option_value, :name => "Color", :presentation => "Green", :option_type => @color)
    @variant1 = Factory(:variant, :product => @product, :option_values => [@s, @red], :on_hand => 0)
    @variant2 = Factory(:variant, :product => @product, :option_values => [@s, @green], :on_hand => 0)
    @variant3 = Factory(:variant, :product => @product, :option_values => [@m, @red], :on_hand => 0)
    @variant4 = Factory(:variant, :product => @product, :option_values => [@m, @green], :on_hand => 1)
  end

  test 'allow choose out of stock variants' do
    SpreeVariantOptions::VariantConfig.allow_select_outofstock = true

    visit spree.product_path(@product)
    within("#product-variants") do
      size = find_link('S')
      size.click
      assert size["class"].include?("selected")
      color = find_link('Green')
      color.click
      assert color["class"].include?("selected")
    end
    # add to cart button is still disabled
    assert find_button("Add To Cart")["disabled"]
  end

  test 'disallow choose out of stock variants' do
    SpreeVariantOptions::VariantConfig.allow_select_outofstock = false
    pending "SpreeVariantOptions::VariantConfig[:allow_select_outofstock] is still true in selenium..."

    visit spree.product_path(@product)
    within("#product-variants") do
      size = find_link('M')
      size.click
      assert !size["class"].include?("selected")
      color = find_link('Red')
      color.click
      assert !color["class"].include?("selected")
    end
    # add to cart button is still disabled
    assert find_button("Add To Cart")["disabled"]
  end

end
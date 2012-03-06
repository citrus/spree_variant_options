require 'test_helper'

class Spree::ProductTest < ActiveSupport::TestCase

  setup do
    @methods = %w(option_values grouped_option_values variant_options_hash)
  end
  
  context "any product" do
  
    setup do
      @product = Factory.create(:product)
    end
  
    should "have proper methods" do
      @methods.each do |m|
        assert @product.respond_to?(m)
      end
    end
        
  end
  
  
  context "a product with variants" do
    
    setup do
      @product = Factory.create(:product_with_variants)
    end
    
    should "have variants and option types and values" do
      assert_equal 2,  @product.option_types.count
      assert_equal 12, @product.option_values.count
      assert_equal 32, @product.variants.count
    end
    
    should "fetch all unique option values" do
      unused = Factory(:option_value, :option_type => @product.option_types.first, :presentation => "Unused")
      assert !@product.option_values.include?(unused)
    end
    
    should "retain option values sort order" do
      @product.option_types.each_with_index {|ot, i| ot.update_attribute(:position, i + 1) }
      assert_equal [1,2], @product.option_values.map {|ov| ov.option_type.reload.position }.uniq
      assert_equal [1,2], @product.option_values.map(&:position).uniq
    end
    
    should "have values grouped by type" do
      expected = { "size" => 4, "color" => 8 }
      assert_equal 2,  @product.grouped_option_values.count
      @product.grouped_option_values.each do |type, values|
        assert_equal expected[type.name], values.length
      end
    end
    
  end
    
end

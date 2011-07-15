require_relative '../test_helper'

class OptionValueTest < ActiveSupport::TestCase

  setup do
    @images = Dir[File.expand_path("../../dummy/db/sample/assets/*", __FILE__)]
  end

  should_have_attached_file :image
  
  context "a new option value" do
  
    setup do
      @option_value = OptionValue.new
    end
  
    should "not have an image" do
      assert !@option_value.has_image?
    end
  
  end
  
  context "an existing option value" do
  
    setup do
      @option_value = Factory.create(:option_value)
    end
  
    should "not have an image" do
      assert !@option_value.has_image?
    end
    
    context "with an image" do
      
      setup do
        @path = @images.shuffle.first
        file = File.open(@path)
        @option_value.image = file
        @option_value.save
        file.close
      end
      
      should "have an images" do
        assert @option_value.has_image?
        dir = File.expand_path("../../dummy/public/assets/option_values/#{@option_value.id}", __FILE__)
        %w(small large original).each do |size|
          assert File.exists?(File.join(dir, size, File.basename(@path)))
        end        
      end
      
    end  
  
  end
  
end

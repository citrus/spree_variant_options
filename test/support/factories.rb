FactoryGirl.define do

  factory :product, :class => Spree::Product do
    name "Very Wearily Variantly"
    description "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nulla nonummy aliquet mi. Proin lacus. Ut placerat. Proin consequat, justo sit amet tempus consequat, elit est adipiscing odio, ut egestas pede eros in diam. Proin varius, lacus vitae suscipit varius, ipsum eros convallis nisi, sit amet sodales lectus pede non est. Duis augue. Suspendisse hendrerit pharetra metus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Curabitur nec pede. Quisque volutpat, neque ac porttitor sodales, sem lacus rutrum nulla, ullamcorper placerat ante tortor ac odio. Suspendisse vel libero. Nullam volutpat magna vel ligula. Suspendisse sit amet metus. Nunc quis massa. Nulla facilisi. In enim. In venenatis nisi id eros. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nunc sit amet felis sed lectus tincidunt egestas. Mauris nibh."
    available_on { Time.zone.now - 1.day }
    permalink "very-wearily-variantly"
    price 17.00
    count_on_hand 10
  end
  
  factory :product_with_variants, :parent => :product do
    after_create { |product|
      sizes = %w(Small Medium Large X-Large).map{|i| Factory.create(:option_value, :presentation => i) }
      colors = %w(Red Green Blue Yellow Purple Gray Black White).map{|i| 
        Factory.create(:option_value, :presentation => i, :option_type => Spree::OptionType.find_by_name("color") || Factory.create(:option_type, :presentation => "Color")) 
      }
      product.variants = sizes.map{|i| colors.map{|j| Factory.create(:variant, :product => product, :option_values => [i, j]) }}.flatten
      product.option_types = Spree::OptionType.where(:name => %w(size color))
    }
  end
  
  factory :variant, :class => Spree::Variant do
    product { Spree::Product.last || Factory.create(:product) }
    option_values { [OptionValue.last || Factory.create(:option_value)] }
    sequence(:sku) { |n| "ROR-#{1000 + n}" }
    sequence(:price) { |n| 19.99 + n }
    cost_price 17.00
    count_on_hand 10
  end
  
  factory :option_type, :class => Spree::OptionType do
    presentation "Size"
    name { presentation.downcase }
    #sequence(:position) {|n| n }
  end
  
  factory :option_value, :class => Spree::OptionValue do
    presentation "Large"
    name { presentation.downcase }
    option_type { Spree::OptionType.last || Factory.create(:option_type) }
    #sequence(:position) {|n| n }
  end

end

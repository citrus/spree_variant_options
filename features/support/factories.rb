FactoryGirl.define do

  factory :product do
    name "Very Wearily Variantly"
    description "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nulla nonummy aliquet mi. Proin lacus. Ut placerat. Proin consequat, justo sit amet tempus consequat, elit est adipiscing odio, ut egestas pede eros in diam. Proin varius, lacus vitae suscipit varius, ipsum eros convallis nisi, sit amet sodales lectus pede non est. Duis augue. Suspendisse hendrerit pharetra metus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Curabitur nec pede. Quisque volutpat, neque ac porttitor sodales, sem lacus rutrum nulla, ullamcorper placerat ante tortor ac odio. Suspendisse vel libero. Nullam volutpat magna vel ligula. Suspendisse sit amet metus. Nunc quis massa. Nulla facilisi. In enim. In venenatis nisi id eros. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nunc sit amet felis sed lectus tincidunt egestas. Mauris nibh."
    available_on { Time.zone.now - 1.day }
    permalink "very-wearily-variantly"
    price 17.00
    count_on_hand 10
  end
  
  factory :variant do
    product { Product.last || Factory.create(:product) }
    option_values { [OptionValue.last || Factory.create(:option_value)] }
    sequence(:sku) { |n| "ROR-0000#{n}" }
    price 19.99
    cost_price 17.00
    count_on_hand 10
  end
  
  factory :option_type do
    presentation "Size"
    name { presentation.downcase }
    position 1
  end
  
  factory :option_value do
    presentation "Large"
    name { presentation.downcase }
    option_type { OptionType.last || Factory.create(:option_type) }
  end

end

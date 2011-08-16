Variant.class_eval do
  
  include ActionView::Helpers::NumberHelper
  
  def variant_options_hash
    { 
      :id => self.id, 
      :count => self.count_on_hand, 
      :price => number_to_currency(self.price)
    }
  end
    
end
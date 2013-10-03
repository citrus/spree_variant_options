Spree::Variant.class_eval do
  
  include ActionView::Helpers::NumberHelper
  
  attr_accessible :option_values
  
  def to_hash
    actual_price  = self.price
    #actual_price += Calculator::Vat.calculate_tax_on(self) if Spree::Config[:show_price_inc_vat]
    { 
      :id    => self.id,
      :count => self.stock_items.sum(&:count_on_hand),
      :price => number_to_currency(actual_price),
      :backorderable => self.stock_items.where(:backorderable => true).any?
    }
  end
    
end

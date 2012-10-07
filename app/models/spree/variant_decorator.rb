Spree::Variant.class_eval do

  include ActionView::Helpers::NumberHelper

  attr_accessible :option_values

  def to_hash
    actual_price  = self.price
    #actual_price += Calculator::Vat.calculate_tax_on(self) if Spree::Config[:show_price_inc_vat]
    {
      :id    => self.id,
      :count => self.count_on_hand,
      :price => Spree::Money.new(actual_price).to_s
    }
  end

end

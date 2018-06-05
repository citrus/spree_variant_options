require 'spec_helper'

describe Spree::Product do
  let(:product) { FactoryGirl.create(:product) }

  describe 'Associations' do
    it { should have_many(:option_values).through(:variants) }
  end

  describe 'Instance Methods' do

    describe '#ordered_option_types' do
      before { FactoryGirl.create_list(:product_option_type, 2, product: product) }

      it 'returns option_types' do
        expect(product.ordered_option_types.collect(&:product_ids).flatten.uniq).to eq [product.id]
      end

      it 'returns option_types in assending order' do
        expect(product.ordered_option_types).to eq product.option_types.order(:position)
      end
    end

    describe '#variants_option_value_details' do
      before do
        @option_type = FactoryGirl.create(:product_option_type, product: product).option_type
        variant1, variant2 = FactoryGirl.create_list(:variant, 2, product: product)
        option_value1, option_value2 = FactoryGirl.create_list(:option_value, 2, option_type: @option_type)
        variant1.option_values = [option_value1]
        variant2.option_values = [option_value2]
      end

      it 'returns option_types' do
        expect(product.variants_option_value_details).to eq(
          product.variants.reload.collect do |variant|
            {
              in_stock: variant.can_supply?,
              variant_id: variant.id,
              variant_price: variant.price_in(Spree::Config[:currency]).money,
              option_types: { @option_type.id => variant.option_value_ids.last }
            }
          end
        )
      end
    end
  end
end

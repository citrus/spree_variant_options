require 'spec_helper'

describe Spree::Variant do
  let(:product) { FactoryBot.create(:product) }
  let(:saved_variant) { FactoryBot.create(:variant, product: product) }
  let(:saved_variant2) { FactoryBot.create(:variant, product: product) }

  describe "#option_values" do
    context "on create" do
      it "should validate that option values are unique for created variant" do
        variant = FactoryBot.build(:variant, product_id: product.id, option_values: saved_variant.option_values)
        expect(variant).to_not be_valid
        expect(variant.errors.messages[:base]).to eq(['Already created a variant with the same option values'])
      end
    end

    context "on update" do
      it "should validate that option values are unique for updated variant" do
        saved_variant2.option_values = saved_variant.option_values
        saved_variant2.reload.valid?
        expect(saved_variant2).to_not be_valid
        expect(saved_variant2.errors.messages[:base]).to eq(['Already created a variant with the same option values'])
      end
    end
  end
end

require 'spec_helper'

describe Spree::Variant do
  let(:product) { create(:product) }
  let(:saved_variant) { create(:variant, product: product) }
  let(:saved_variant2) { create(:variant, product: product) }

  describe "#option_values" do
    context "on create" do
      before do
         @variant = build(:variant, product_id: product.id, option_values: saved_variant.option_values)
      end

      it "should validate that option values are unique for created variant" do
        expect(@variant).to_not be_valid
        expect(@variant.errors.messages[:base]).to eq([Spree.t(:already_created)])
      end
    end

    context "on update" do
      before do
        saved_variant2.option_values = saved_variant.option_values
        saved_variant2.reload.valid?
      end

      it "should validate that option values are unique for updated variant" do
        expect(saved_variant2).to_not be_valid
        expect(saved_variant2.errors.messages[:base]).to eq([Spree.t(:already_created)])
      end
    end
  end
end

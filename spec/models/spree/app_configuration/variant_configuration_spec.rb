require 'spec_helper'

describe SpreeVariantOptions::VariantConfiguration do

  describe 'allow_select_outofstock' do
    it { expect(SpreeVariantOptions::VariantConfig).to have_preference(:allow_select_outofstock) }
    it { expect(SpreeVariantOptions::VariantConfig.preferred_allow_select_outofstock_type).to eq(:boolean) }
    it { expect(SpreeVariantOptions::VariantConfig.preferred_allow_select_outofstock_default).to eq(false) }
  end

  describe 'default_instock' do
    it { expect(SpreeVariantOptions::VariantConfig).to have_preference(:default_instock) }
    it { expect(SpreeVariantOptions::VariantConfig.preferred_default_instock_type).to eq(:boolean) }
    it { expect(SpreeVariantOptions::VariantConfig.preferred_default_instock_default).to eq(false) }
  end

end

require 'spec_helper'

feature "Products variant options", js: true do
  let(:option_type1) { create(:option_type, name: "size", presentation: "Size") }
  let(:option_type2) { create(:option_type, name: "color", presentation: "Color") }
  let(:option_value1) { create(:option_value, name: "small", presentation: "Small", option_type: option_type1) }
  let(:option_value2) { create(:option_value, name: "medium", presentation: "Medium", option_type: option_type1) }
  let(:option_value3) { create(:option_value, name: "red", presentation: "Red", option_type: option_type2) }
  let(:option_value4) { create(:option_value, name: "green", presentation: "Green", option_type: option_type2) }
  let(:product) { create(:product_with_option_types, name: "Mug") }
  let(:variant1) { create(:variant, product: product, option_values: [option_value1, option_value3]) }
  let(:variant2) { create(:variant, product: product, option_values: [option_value1, option_value4]) }
  let(:variant3) { create(:variant, product: product, option_values: [option_value2, option_value3]) }
  let(:variant4) { create(:variant, product: product, option_values: [option_value2, option_value4]) }

  context "variant options on product page" do
    before do
      product.option_types = [option_type1, option_type2]
      variant1
      variant2
      variant3
      variant4
    end

    scenario "expect to see enabled links for the first option type" do
      visit spree.product_path(product)
      within "div.variant-options.index-0" do
        expect(page).to_not have_css('a.option-value.locked')
      end
    end

    scenario "expect to see disabled links for the second option type" do
      visit spree.product_path(product)
      within "div.variant-options.index-1" do
        expect(page).to have_css('a.option-value.locked')
      end
    end

    scenario "expect to have a hidden input for the selected variant" do
      visit spree.product_path(product)
      within 'div#product-variants' do
        expect(page).to have_css('input#variant_id', visible: false)
      end
    end

    scenario "expect to have a disabled add to cart button" do
      visit spree.product_path(product)
      within "div.add-to-cart" do
        expect(page).to have_css('button#add-to-cart-button[disabled]')
      end
    end
  end

  context "option value images" do
    let(:option_value1) { create(:option_value, name: "small", presentation: "Small", option_type: option_type1, image: image_file) }
    let(:image_file) { File.open(Rails.root + '../..' + 'spec/image/img.png') }

    before do
      product.option_types = [option_type1, option_type2]
      variant1
      variant2
      variant3
      variant4
    end

    scenario "expect to see option value image" do
      visit spree.product_path(product)
      within "div.variant-options.index-0 a[title='Small']" do
        expect(page).to have_css('img[src*="img.png"]')
      end
    end
  end

  context "when variant options changed" do
    before do
      product.option_types = [option_type1, option_type2]
      variant1
      variant2
      variant3
      variant4
    end

    context "when clicked on option value within first option type" do
      before do
        visit spree.product_path(product)
        page.find('a.option-value[title="Small"]').click
      end

      scenario "expect to see enabled links for the second option type" do
        within "div.variant-options.index-1" do
          expect(page).to_not have_css('a.option-value.locked')
        end
      end

      context "when clicked on option value within second option type" do
        before do
          page.find('a.option-value[title="Red"]').click
        end

        scenario "expect to have a enabled add to cart button" do
          within "div.add-to-cart" do
            expect(page.find('button#add-to-cart-button').disabled?).to be_falsey
          end
        end
      end
    end
  end

  context "when out-of-stock non-backorderable variants present" do
    let(:variant2) do
      variant = create(:variant, product: product, option_values: [option_value1, option_value4])
      variant.stock_items.each { |si| si.update_attributes(count_on_hand: 0, backorderable: false) }
      variant
    end

    before do
      product.option_types = [option_type1, option_type2]
      variant1
      variant2
      variant3
      variant4
    end

    context "when clicked on option value within first option type" do
      before do
        visit spree.product_path(product)
        page.find('a.option-value[title="Small"]').click
      end

      scenario "expect to see out-of-stock link for out-of-stock variant within the second option type" do
        within "div.variant-options.index-1" do
          expect(page).to have_css('a.option-value.locked.out-of-stock[title="Green"]')
        end
      end

      scenario "expect to see in-stock link for in-stock variant within the second option type" do
        within "div.variant-options.index-1" do
          expect(page).to have_css('a.option-value[title="Red"]')
        end
      end

      scenario "expect not to see disabled link for in-stock variant within the second option type" do
        within "div.variant-options.index-1" do
          expect(page).to_not have_css('a.option-value.locked[title="Red"]')
        end
      end
    end
  end

  context "when out-of-stock backorderable variants present" do
    let(:variant2) do
      variant = create(:variant, product: product, option_values: [option_value1, option_value4])
      variant.stock_items.each { |si| si.update_attributes(count_on_hand: 0, backorderable: true) }
      variant
    end

    before do
      product.option_types = [option_type1, option_type2]
      variant1
      variant2
      variant3
      variant4
    end

    context "when clicked on option value within first option type" do
      before do
        visit spree.product_path(product)
        page.find('a.option-value[title="Small"]').click
      end

      scenario "expect to see in-stock link for out-of-stock backorderable variant within the second option type" do
        within "div.variant-options.index-1" do
          expect(page).to have_css('a.option-value[title="Green"]')
        end
      end

      scenario "expect not to see out-of-stock link for out-of-stock backorderable variant within the second option type" do
        within "div.variant-options.index-1" do
          expect(page).to_not have_css('a.option-value.locked.out-of-stock[title="Green"]')
        end
      end
    end
  end

  context "when clearing option selected" do
    before do
      product.option_types = [option_type1, option_type2]
      variant1
      variant2
      variant3
      variant4
    end

    context "when clicked on option value within first option type" do
      before do
        visit spree.product_path(product)
        page.find('a.option-value[title="Small"]').click
      end

      context "when clearing within first option type" do
        before do
          page.find('div.variant-options.index-0 a.clear-button').click
        end

        scenario "expect to see enabled links for the first option type" do
          within "div.variant-options.index-0" do
            expect(page).to_not have_css('a.option-value.locked')
          end
        end

        scenario "expect to see disabled links for the second option type" do
          within "div.variant-options.index-1" do
            expect(page).to have_css('a.option-value.locked')
          end
        end
      end
    end
  end
end

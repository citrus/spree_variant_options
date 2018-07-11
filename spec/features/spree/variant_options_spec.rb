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
  let(:variant4) { create(:variant, product: product, option_values: [option_value1]) }


  context "variant options on product page" do
    before do
      product.option_types = [option_type1, option_type2]
      variant1
      variant2
      variant3
      variant4
    end

    scenario "expect to see enabled links for the first(ALL) option type" do
      visit spree.product_path(product)
      within "div.variant-options" do
        expect(page).to_not have_css('a.option-value.locked')
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

      scenario "expect to have value for selected variant" do
        within 'div#product-variants' do
          expect(page.find('input#variant_id', visible: false).value).to_not be_blank
        end
      end

      scenario "expect to have an enabled add to cart button" do
        within "div.add-to-cart" do
          expect(page.find('button#add-to-cart-button').disabled?).to be_falsey
        end
      end

      context "when clicked on option value within second option type" do
        before do
          page.find('a.option-value[title="Red"]').click
        end

        scenario "expect to have an enabled add to cart button" do
          within "div.add-to-cart" do
            expect(page.find('button#add-to-cart-button').disabled?).to be_falsey
          end
        end

        scenario "expect to have value for selected variant" do
          within 'div#product-variants' do
            expect(page.find('input#variant_id', visible: false).value).to_not be_blank
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
        page.find('a.option-value[title="Green"]').click
      end

      scenario "expect to see out-of-stock link for out-of-stock variant " do
        within "div.variant-options.index-1" do
          expect(page).to have_css('a.option-value.out-of-stock[title="Green"]')
        end
      end

      scenario "expect to see in-stock link for in-stock variant within the second option type" do
        within "div.variant-options.index-1" do
          expect(page).to have_css('a.option-value[title="Red"]')
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
          expect(page).to_not have_css('a.option-value.out-of-stock[title="Green"]')
        end
      end
    end
  end

  context "add proper variant to cart" do
    before do
      product.option_types = [option_type1, option_type2]
      variant1
      variant2
      variant3
      variant4
      visit spree.product_path(product)
    end

    context "when add variant to cart" do
      before do
        page.find('a.option-value[title="Small"]').click
        page.find('a.option-value[title="Green"]').click
        page.find('button#add-to-cart-button').click
      end

      scenario "expect to see variant added to cart" do
        within 'tbody#line_items .cart-item-description' do
          expect(page).to have_content('Size: Small, Color: Green')
        end
      end
    end
  end

  context "auto-select variant if its the only option" do
    before do
      product.option_types = [option_type1, option_type2]
      variant1
      variant2
      variant3
      variant4
      visit spree.product_path(product)
    end

    context "when clicked on option value within first option type" do
      before do
        page.find('a.option-value[title="Medium"]').click
      end

      scenario "expect to have all option-values for this variant selected" do
        within "div.variant-options.index-1" do
          expect(page).to have_css('a.option-value[title="Red"].selected')
        end
      end

      scenario "expect to have an enabled add to cart button" do
        within "div.add-to-cart" do
          expect(page.find('button#add-to-cart-button').disabled?).to be_falsey
        end
      end

      scenario "expect to have value for selected variant" do
        within 'div#product-variants' do
          expect(page.find('input#variant_id', visible: false).value).to_not be_blank
        end
      end
    end
  end
end

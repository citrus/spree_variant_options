require 'spec_helper'

feature "Admin Option Values", js: true do

  stub_authorization!

  def create_option_value_and_go_to_option_type(with_image = true)
    visit spree.edit_admin_option_type_path(option_type)
    fill_in 'option_type[option_values_attributes][0][name]', with: 'small'
    fill_in 'option_type[option_values_attributes][0][presentation]', with: 'Small'
    attach_file 'option_type[option_values_attributes][0][image]', Rails.root + '../..' + 'spec/image/img.png' if with_image
    click_button 'Update'
    visit spree.edit_admin_option_type_path(option_type)
  end

  let!(:option_type) { create(:option_type, name: "Size", presentation: "Size") }

  scenario 'option value creation' do
    create_option_value_and_go_to_option_type
    within 'tbody#option_values tr' do
      expect(page).to have_selector("img[src*='img.png']")
    end
  end

  scenario 'option value updation' do
    create_option_value_and_go_to_option_type(false)
    attach_file 'option_type[option_values_attributes][0][image]', Rails.root + '../..' + 'spec/image/img.png'
    click_button 'Update'
    visit spree.edit_admin_option_type_path(option_type)
    within 'tbody#option_values tr' do
      expect(page).to have_selector("img[src*='img.png']")
    end
  end

  scenario 'option value deletion' do
    create_option_value_and_go_to_option_type
    find("tbody#option_values tr [data-action='remove']").click
    wait_for_ajax
    within 'tbody#option_values' do
      expect(page).to_not have_selector("img[src*='img.png']")
    end
  end
end

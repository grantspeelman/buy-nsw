require 'rails_helper'

RSpec.describe 'Product onboarding', type: :feature, js: true, user: :seller_user_with_seller do

  let(:existing_application) {
    create(:created_seller_version, seller: @user.seller)
  }

  before(:each) {
    @user.seller.update_attribute(:services, ['cloud-services'])
  }

  it 'can complete product basics' do
    visit sellers_application_products_path(existing_application)

    click_on product_label(:new_product_action_label)
    click_on step_label(:basics)

    fill_in field_label(:basics, :name), with: 'Name'
    fill_in field_label(:basics, :summary), with: 'Summary'

    within_fieldset field_label(:basics, :audiences) do
      check enumerize_value(:audiences, 'data-analytics')
    end

    within_fieldset field_label(:basics, :features, key: :title) do
      fill_in '1', with: 'Feature 1'
      fill_in '2', with: 'Feature 2'
      8.times do |i|
        click_on 'Add another feature'
        fill_in i+3, with: "Feature #{i+3}"
      end
    end

    within_fieldset field_label(:basics, :benefits, key: :title) do
      fill_in '1', with: 'Benefit 1'
      fill_in '2', with: 'Benefit 2'
      8.times do |i|
        click_on 'Add another benefit'
        fill_in i+3, with: "Benefit #{i+3}"
      end
    end

    within_fieldset field_label(:basics, :reseller_type) do
      choose enumerize_value(:reseller_type, 'own-product')
    end

    within_fieldset field_label(:basics, :custom_contact) do
      choose field_label(:basics, :custom_contact, key: :false_label)
    end

    click_button 'Save'

    expect(page).to have_content('Your changes have been saved')
  end

  def step_label(key)
    I18n.t("#{key}.short", scope: [:sellers, :applications, :products, :steps])
  end

  def field_label(step, field, key: 'label')
    I18n.t("#{field}.#{key}", scope: [:sellers, :applications, :products, :steps, step])
  end

  def product_label(key)
    I18n.t(key, scope: [:sellers, :applications, :products])
  end

  def enumerize_value(field, value)
    I18n.t(value, scope: [:enumerize, :product, field])
  end

end

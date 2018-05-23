require 'rails_helper'

RSpec.describe 'Buyer onboarding', type: :feature, js: true, skip_login: true do

  describe 'as a buyer with a government email' do
    let(:user) { build(:buyer_user_with_approved_email) }

    it 'submits a valid employee application' do
      visit '/register/buyer'

      complete_buyer_sign_up(user)
      confirm_email_address(user)

      fill_in_buyer_details

      # NOTE: All employees now must complete the application form
      fill_in_application_body

      fill_in_employment_status(:employee)
      review_and_submit

      expect_submission_message
    end

    it 'submits a valid contractor application' do
      visit '/register/buyer'

      complete_buyer_sign_up(user)
      confirm_email_address(user)

      fill_in_buyer_details

      # NOTE: All employees now must complete the application form
      fill_in_application_body

      fill_in_employment_status(:contractor)
      fill_in_manager_details
      review_and_submit

      expect_submission_message
    end
  end

  describe 'as a buyer with a non-government email' do
    let(:user) { build(:buyer_user_without_approved_email) }

    it 'submits a valid employee application' do
      visit '/register/buyer'

      complete_buyer_sign_up(user)
      confirm_email_address(user)

      fill_in_buyer_details
      fill_in_application_body
      fill_in_employment_status(:employee)
      review_and_submit
    end

    it 'submits a valid contractor application' do
      visit '/register/buyer'

      complete_buyer_sign_up(user)
      confirm_email_address(user)

      fill_in_buyer_details
      fill_in_application_body
      fill_in_employment_status(:contractor)
      fill_in_manager_details
      review_and_submit

      expect_submission_message
    end
  end

  def complete_buyer_sign_up(user)
    password = SecureRandom.hex(8)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    fill_in 'Confirm', with: password
    click_on 'Continue'

    expect(page).to have_content('Confirm your email')
  end

  def confirm_email_address(user)
    token = User.find_by_email(user.email).confirmation_token
    visit user_confirmation_path(confirmation_token: token)

    expect(page).to have_content('Thanks for confirming')
  end

  def fill_in_buyer_details
    fill_in 'Full name', with: 'Sir Buy-a-lot'
    fill_in 'Organisation name', with: 'Department of Buying Things'

    click_on 'Save and continue'
  end

  def fill_in_application_body
    fill_in 'buyer_application[application_body]', with: 'I am an authorised buyer from another agency'

    click_on 'Save and continue'
  end

  def fill_in_employment_status(status)
    choose "I'm a NSW Government employee" if status == :employee
    choose "I'm a contractor" if status == :contractor

    click_on 'Save and continue'
  end

  def fill_in_manager_details
    fill_in "Your manager's full name", with: 'Manager Manager'
    fill_in "Your manager's email", with: 'm.manager@example.org'

    click_on 'Save and continue'
  end

  def review_and_submit
    click_on 'Submit application'
  end

  def expect_submission_message
    expect(page).to have_content('Your application has been submitted.')
  end

end

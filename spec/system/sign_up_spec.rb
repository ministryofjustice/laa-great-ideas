# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign up', type: :system do
  describe 'signing up as a new user' do
    it 'should allow .justice.gov.uk email addresses' do
      visit new_user_registration_path
      fill_in 'user_email', with: 'user@justice.gov.uk'
      fill_in 'user_password', with: 'change_me'
      fill_in 'user_password_confirmation', with: 'change_me'
      expect_any_instance_of(DeviseCustomMailer).to receive(:confirmation_instructions).and_call_original
      click_button 'Sign up'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
    end

    it 'should allow digital.justice.gov.uk email addresses' do
      visit new_user_registration_path
      fill_in 'user_email', with: 'user@digital.justice.gov.uk'
      fill_in 'user_password', with: 'change_me'
      fill_in 'user_password_confirmation', with: 'change_me'
      click_button 'Sign up'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
    end

    it 'should not allow non justice.gov.uk email addresses' do
      visit new_user_registration_path
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'change_me'
      fill_in 'user_password_confirmation', with: 'change_me'
      click_button 'Sign up'
      expect(page).to have_content 'Email must end in justice.gov.uk'
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing an idea', type: :system do
  let(:default_user) { create :user }
  let(:admin_user) { create :admin }
  let(:default_user_2) { create :user, email: 'test@justice.gov.uk' }
  let(:idea) { create :idea, user: default_user_2, idea: 'This idea is ok' }
  let(:my_idea) { create :idea, user: default_user, idea: 'This idea is ok' }
  let(:it_idea) { create :complete_idea, user: admin_user }
  let(:business_idea) { create :complete_idea, user: admin_user }

  before do
    sign_in default_user
  end

  context 'as a normal user' do
    describe 'editing another users idea' do
      it 'should give an error' do
        visit edit_idea_path(idea)
        expect(page).to have_text('You are not authorised to amend this idea.')
      end
    end

    describe 'editing my own idea' do
      it 'should update the idea' do
        visit idea_path(my_idea)
        click_on 'Edit'
        fill_in 'Idea', with: 'This is a great idea'
        click_button 'Update'
        my_idea.reload
        expect(my_idea.idea).to eq 'This is a great idea'
        expect(page).to have_text('This is a great idea')
      end
    end
  end

  context 'as an admin user' do
    before do
      sign_in admin_user
    end

    describe 'editing my submitted idea with a valid it system' do
      it 'should update the idea' do
        visit idea_path(it_idea)
        click_button 'Submit idea'
        visit edit_idea_path(it_idea)
        page.select 'IT Development', from: 'idea_area_of_interest'
        page.select 'CCMS', from: 'idea_it_system'
        click_button 'Update Idea'
        it_idea.reload
        expect(page).to have_text('CCMS')
        expect(it_idea.it_system).to eq 'ccms'
        expect(page).to have_text('Idea was successfully updated')
      end
    end

    describe 'editing my submitted idea with an invalid business area' do
      it 'should not update the idea' do
        visit idea_path(business_idea)
        click_button 'Submit idea'
        visit edit_idea_path(business_idea)
        page.select 'Equality and Diversity', from: 'idea_area_of_interest'
        page.select 'Civil', from: 'idea_business_area'
        click_button 'Update Idea'
        expect(business_idea.business_area).to be_nil
        expect(page).to have_text('Business Area invalid area of interest')
      end
    end
  end
end

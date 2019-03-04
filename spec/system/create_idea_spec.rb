# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Idea creation', type: :system do
  let(:default_user) { create :user }

  before do
    sign_in default_user
  end

  describe 'creating an idea' do
    it 'should allow an idea to becreated' do
      visit ideas_path
      click_on 'New Idea'
      expect(page).to have_text('New Idea')
      page.select 'IT Development', from: 'idea_area_of_interest'
      page.select 'Crime', from: 'idea_business_area'
      page.select 'CCMS', from: 'idea_it_system'
      fill_in 'idea_title', with: 'System test idea'
      fill_in 'idea_idea', with: 'System test idea body content'
      page.check('idea_benefit_list_cost')
      fill_in 'idea_impact', with: 'Impact comments'
      page.select 'No involvement', from: 'idea_involvement'
      click_button 'Create Idea'
      expect(page).to have_text('Idea was successfully created.')
      expect(page).to have_text('System test idea')
    end
  end
end

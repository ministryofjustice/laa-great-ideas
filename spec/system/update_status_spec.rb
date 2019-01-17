# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update status', type: :system do
  let(:default_user) { create :user }
  let(:admin_user) { create :admin }
  let(:idea) { create :idea }

  describe 'user updating an idea' do
    it 'should not be possible to update the status of the idea' do
      sign_in default_user
      visit edit_idea_path(idea)
      expect(page).not_to have_select('idea_status')
    end
  end

  describe 'admin user updating an idea' do
    it 'should be possible to update the status of the idea' do
      sign_in admin_user
      visit edit_idea_path(idea)
      expect(page).to have_select('idea_status')
      select 'Approved', from: 'idea_status'
      click_button 'Update Idea'
      idea.reload
      expect(idea.status).to eq('approved')
      expect(page).to have_text('Idea was successfully updated')
      visit ideas_path
      expect(page).to have_text('approved')
    end
  end
end

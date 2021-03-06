# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Assign idea', type: :system do
  let(:default_user) { create :user }
  let(:admin_user) { create :admin }
  let(:idea) { create :idea, user: default_user }

  describe 'user creating an idea' do
    it 'should not be possible to assign the idea' do
      sign_in default_user
      visit edit_idea_path(idea)
      expect(page).not_to have_select('idea_assigned_user_id')
      expect(page).not_to have_select('idea_participation_level')
    end
  end

  describe 'admin user assigning an idea' do
    it 'should be possible to assign the idea' do
      sign_in admin_user
      visit edit_idea_path(idea)
      expect(page).to have_select('idea_assigned_user_id')
      expect(page).to have_select('idea_involvement')
      select 'admin@justice.gov.uk', from: 'idea_assigned_user_id'
      select 'I want to be involved', from: 'idea_involvement'
      expect_any_instance_of(IdeaMailer).to receive(:assigned_idea_email_template).and_call_original
      click_button 'Update Idea'
      idea.reload
      expect(idea.assigned_user_id).to eq(admin_user.id)
      expect(idea.involvement).to eq 'i_want_to_be_involved'
      expect(page).to have_text('Idea was successfully updated')
      visit ideas_path(view: 'assigned')
      expect(page).to have_text('New idea1')
    end
  end
end

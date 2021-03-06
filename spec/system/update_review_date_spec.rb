# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update review date', type: :system do
  let(:admin_user) { create :admin }
  let(:idea) { create :idea }

  describe 'admin user updating an idea' do
    it 'should be possible to update an idea with a valid review date' do
      sign_in admin_user
      visit edit_idea_path(idea)
      fill_in('idea_review_year', with: Date.today.year)
      fill_in('idea_review_month', with: Date.today.month)
      fill_in('idea_review_day', with: Date.today.day)
      click_button 'Update Idea'
      idea.reload
      expect(idea.review_date).to eq(Date.today)
      expect(page).to have_text('Idea was successfully updated')
    end

    it 'should not be possible to update an idea with a future review date' do
      sign_in admin_user
      visit edit_idea_path(idea)
      fill_in('idea_review_year', with: Date.yesterday.year)
      fill_in('idea_review_month', with: Date.yesterday.month)
      fill_in('idea_review_day', with: Date.yesterday.day)
      click_button 'Update Idea'
      expect(page).to have_text('Review date cannot be in the past')
      expect(idea.review_date).to be_nil
    end

    it 'should not be possible to update an idea with an invalid review date' do
      sign_in admin_user
      visit edit_idea_path(idea)
      fill_in('idea_review_year', with: 'text')
      fill_in('idea_review_month', with: 'text')
      fill_in('idea_review_day', with: 'text')
      click_button 'Update Idea'
      expect(idea.review_date).to be_nil
    end
  end
end

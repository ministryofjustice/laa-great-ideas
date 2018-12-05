# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ideas submission', type: :system do
  let(:default_user) { create :user }
  let(:idea) { create :idea }
  let(:complete_idea) { create :complete_idea, user: default_user }

  before do
    sign_in default_user
  end

  describe 'submitting an idea' do
    it 'should set the submission date on an idea' do
      visit idea_path(complete_idea)
      click_button 'Submit idea'
      complete_idea.reload
      expect(complete_idea.submission_date).to_not be_nil
      expect(complete_idea.status).to eq 'awaiting_approval'
      expect(page).to have_text('Idea was successfully submitted.')
    end
  end

  describe 'submitting an idea with missing data' do
    it 'should render the edit page with an error' do
      visit idea_path(idea)
      click_button 'Update Idea'
      idea.reload
      expect(idea.submission_date).to be_nil
      expect(page).to have_text('prohibited this idea from being saved:')
    end
  end
end

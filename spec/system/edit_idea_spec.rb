# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing an idea', type: :system do
  let(:default_user) { create :user }
  let(:default_user_2) { create :user, email: 'test@justice.gov.uk' }
  let(:idea) { create :idea, user: default_user_2, idea: 'This idea is ok' }
  let(:my_idea) { create :idea, user: default_user, idea: 'This idea is ok' }

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
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Add a vote', type: :system do
  let(:default_user) { create :user }
  let(:idea) { create :idea, user: default_user }
  let(:approved_idea) { create :approved_idea, user: default_user }

  context 'a logged in user' do
    before { sign_in default_user }

    context 'with an approved idea' do
      describe 'on the idea show page' do
        it 'can add and remove a vote' do
          visit idea_path(approved_idea)
          click_on 'Vote'
          expect(page).to have_selector(:link_or_button, 'Remove Vote')
          click_on 'Remove Vote'
          expect(page).to have_selector(:link_or_button, 'Vote')
        end
      end
    end

    context 'with an unapproved idea' do
      describe 'on the idea show page' do
        it 'does not show the vote button' do
          visit idea_path(idea)
          expect(page).to_not have_selector(:link_or_button, 'Vote')
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Delete a comment', type: :system do
  let(:default_user) { create :user }
  let(:admin_user) { create :admin }
  let(:other_user) { create :user, email: 'test@justice.gov.uk' }
  let(:approved_idea) { create :approved_idea, user: other_user }
  let(:comment) { create :comment, idea: approved_idea, user: default_user }
  let(:admin_comment) { create :comment, idea: approved_idea, user: admin_user }

  context 'a logged in user' do
    before do
      sign_in default_user
    end

    context 'on the idea show page with comments' do
      describe 'deleting their own comment' do
        it 'deletes a comment when clicking on the delete link' do
          comment
          visit idea_path(approved_idea)
          click_on 'Delete'
          expect(page).to have_text('This comment has been deleted')
        end
      end
    end

    context 'on the idea show page with comments' do
      describe 'deleting another users comment' do
        it 'does not delete a comment when clicking on the delete link' do
          admin_comment
          visit idea_path(approved_idea)
          expect(page).to_not have_link('Delete')
        end
      end
    end
  end

  context 'a logged in admin user' do
    before do
      sign_in admin_user
    end

    context 'on the idea show page with comments' do
      describe 'deleting their own comment' do
        it 'deletes a comment when clicking on the delete link' do
          admin_comment
          visit idea_path(approved_idea)
          click_on 'Delete'
          expect(page).to have_text('This comment has been deleted')
        end
      end
    end

    context 'on the idea show page with comments' do
      describe 'deleting another users comment' do
        it 'does not delete a comment when clicking on the delete link' do
          comment
          visit idea_path(approved_idea)
          click_on 'Delete'
          expect(page).to have_text('This comment has been deleted')
        end
      end
    end
  end
end

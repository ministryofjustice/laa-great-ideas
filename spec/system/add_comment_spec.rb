# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Add a comment', type: :system do
  let(:default_user) { create :user }
  let(:idea) { create :idea }
  let(:comment) { create :comment }

  context 'a logged in user' do
    before do
      sign_in default_user
    end

    describe 'on the idea show page' do
      it 'can click an add comment button' do
        visit idea_path(idea)
        click_on 'Add Comment'
        expect(page).to have_text('New Comment')
      end
    end

    describe 'creating a comment' do
      it 'can create and save a comment' do
        visit new_idea_comment_path(idea)
        expect(page).to have_text('New Comment')
        fill_in('comment_body', with: 'Test comment')
        click_on 'Create Comment'
        expect(page).to have_text('Test comment')
      end

      it 'does not create a comment when blank' do
        visit new_idea_comment_path(idea)
        expect(page).to have_text('New Comment')
        click_on 'Create Comment'
        expect(page).to have_text('prohibited this comment from being saved')
      end
    end

    describe 'editing a comment' do
      it 'can edit and save a comment' do
        visit edit_idea_comment_path(comment.idea, comment)
        expect(page).to have_text('Comment 1')
        fill_in('comment_body', with: 'Test comment')
        click_on 'Update Comment'
        expect(page).to have_text('Test comment')
      end

      it 'does not edit a comment when blank' do
        visit edit_idea_comment_path(comment.idea, comment)
        expect(page).to have_text('Comment 1')
        fill_in('comment_body', with: '')
        click_on 'Update Comment'
        expect(page).to have_text('prohibited this comment from being saved')
      end
    end

    describe 'viewing comments' do
      it 'shows comments under the idea' do
        idea.comments.create!(body: 'Comment 1', user: default_user)
        idea.comments.create!(body: 'Comment 2', user: default_user)
        visit idea_path(idea)
        expect(page).to have_text('Comment 1')
        expect(page).to have_text('Comment 2')
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:default_user) { create :user }
  let(:admin_user) { create :admin }
  let(:idea) { create :idea }
  let(:approved_idea) { create :approved_idea }
  let(:not_proceeding_idea) { create :idea, status: Idea.statuses[:not_proceeding] }
  let(:comment) { create :comment, user: default_user }

  context 'As a logged in user' do
    before { sign_in default_user }

    describe 'GET /comments' do
      it 'returns a list of comments' do
        create :comment, idea_id: idea.id, user: default_user
        create :comment, body: 'Comment 2', idea_id: idea.id, user: default_user
        get idea_comments_path(idea)
        expect(response.body).to include('Comment 1')
        expect(response.body).to include('Comment 2')
      end
    end

    context 'with an approved idea' do
      describe 'POST /comments' do
        it 'creates a new comment' do
          expect do
            post idea_comments_path(approved_idea), params: { comment: { body: 'Test comment' } }
          end.to change(Comment, :count).by(1)
        end

        it 'has a status matching the idea status' do
          post idea_comments_path(approved_idea), params: { comment: { body: 'Test comment' } }
          expect(Comment.last.status_at_comment_time).to eq('approved')
        end
      end

      describe 'GET /comments/new' do
        it 'returns the new comment page' do
          get new_idea_comment_path(approved_idea)
          expect(response.body).to include('New Comment')
        end
      end

      describe 'GET /comment/:id' do
        it 'shows the comment' do
          get idea_comment_path(comment.idea, comment)
          expect(response.body).to include('Comment 1')
        end
      end

      describe 'DELETE /comment' do
        it 'deletes the comment' do
          delete idea_comment_path(comment.idea, comment)
          expect(Comment.exists?(comment.id)).to eq false
        end
      end

      describe 'PATCH /comment' do
        it 'updates a comment' do
          patch idea_comment_path(comment.idea, comment), params: { comment: { body: 'Changed comment' } }
          comment.reload
          expect(comment.body).to eq('Changed comment')
        end

        it 'fails to updates a comment if parameters missing' do
          expect { patch idea_comment_path(comment.idea, comment) } .to raise_error(ActionController::ParameterMissing)
        end
      end
    end

    context 'with an unapproved idea' do
      describe 'POST /comments' do
        it 'does not create a new comment' do
          expect do
            post idea_comments_path(idea), params: { comment: { body: 'Test comment' } }
          end.to change(Comment, :count).by(0)
        end
      end

      describe 'GET /comments/new' do
        it 'redirects to idea' do
          get new_idea_comment_path(idea)
          expect(response).to redirect_to(idea)
        end
      end
    end

    context 'with a not_proceeding idea' do
      describe 'POST /comments' do
        it 'does not create a new comment' do
          expect do
            post idea_comments_path(not_proceeding_idea), params: { comment: { body: 'Test comment' } }
          end.to change(Comment, :count).by(0)
        end
      end

      describe 'GET /comments/new' do
        it 'redirects to idea' do
          get new_idea_comment_path(not_proceeding_idea)
          expect(response).to redirect_to(not_proceeding_idea)
        end
      end
    end
  end

  context 'As an admin user' do
    before { sign_in admin_user }

    context 'with a not proceeding idea' do
      describe 'POST /comments' do
        it 'creates a new comment' do
          expect do
            post idea_comments_path(not_proceeding_idea), params: { comment: { body: 'Test comment' } }
          end.to change(Comment, :count).by(1)
        end
      end

      describe 'GET /comments/new' do
        it 'returns the new comment page' do
          get new_idea_comment_path(not_proceeding_idea)
          expect(response.body).to include('New Comment')
        end
      end
    end
  end

  context "As user who isn't logged in" do
    describe 'GET /comment' do
      it 'redirects to the login page' do
        get idea_comments_path(idea)
        expect(response).to redirect_to user_session_path
      end
    end
  end
end

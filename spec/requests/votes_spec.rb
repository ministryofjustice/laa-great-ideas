# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Votes', type: :request do
  let(:default_user) { create :user }
  let(:idea) { create :idea }
  let(:approved_idea) { create :approved_idea }
  let(:comment) { create :comment }
  let(:vote) { create :vote }

  context 'As a logged in user' do
    before do
      sign_in default_user
    end

    context 'with an approved idea' do
      describe 'POST /votes' do
        it 'creates a new vote' do
          expect do
            post idea_votes_path(approved_idea)
          end.to change(Vote, :count).by(1)
        end
      end

      describe 'DELETE /vote' do
        it 'deletes a vote' do
          expect do
            delete idea_vote_path(approved_idea, vote)
          end.to change(Vote, :count).by(1)
        end
      end
    end

    context 'with an unapproved idea' do
      describe 'POST /vote' do
        it 'does not create a new vote' do
          expect do
            post idea_votes_path(idea)
          end.to change(Comment, :count).by(0)
        end
      end

      describe 'DELETE /vote' do
        it 'does not deletes a vote' do
          expect do
            delete idea_vote_path(idea, vote)
          end.to change(Comment, :count).by(0)
        end
      end
    end
  end

  context "As user who isn't logged in" do
    describe 'POST /vote' do
      it 'redirects to the login page' do
        post idea_votes_path(idea)
        expect(response).to redirect_to user_session_path
      end
    end
  end
end

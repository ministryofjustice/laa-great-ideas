# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ideas', type: :request do
  let(:default_user) { build :user }
  let(:admin_user) { build :admin }
  let(:idea) { create :idea, user: default_user }
  let(:idea_by_admin) { create :idea, user: admin_user }
  let(:idea2) { create :idea, title: 'New idea2', user: default_user }
  let(:complete_idea) { create :complete_idea }
  let(:submitted_idea) { create :submitted_idea }
  let(:it_idea) { create :idea, user: default_user }

  describe 'As a logged in user' do
    before do
      sign_in default_user
    end

    describe 'GET /ideas' do
      it 'should show a list of ideas' do
        idea
        idea2
        get ideas_path
        expect(response).to have_http_status(200)
        expect(response.body).to include 'New idea1'
        expect(response.body).to include 'New idea2'
      end

      it 'should not show a users button' do
        get ideas_path
        expect(response.body).not_to include '<a href="/users">Users</a>'
      end
    end

    describe 'POST /ideas' do
      it 'should create a new idea' do
        expect do
          post ideas_path, params: { idea: { title: 'Test title' } }
        end.to change(Idea, :count).by(1)

        expect(response).to have_http_status(302)
        expect(idea.draft?).to be true
      end
      it 'should create a new idea with benefits' do
        expect do
          post ideas_path, params: { idea: { title: 'Test title' }, benefits: %i[cost time_saved] }
        end.to change(Idea, :count).by(1)

        expect(response).to have_http_status(302)
        expect(idea.draft?).to be true
      end
    end

    describe 'PATCH /idea' do
      it 'should not show admin only fields' do
        get edit_idea_path(idea)
        expect(response.body).not_to include 'assigned_user_id'
        expect(response.body).not_to include 'status'
        expect(response.body).not_to include 'participation_level'
        expect(response.body).not_to include 'review_date'
      end
    end

    describe 'update an idea' do
      it 'should change an existing idea' do
        patch idea_path(idea), params: { idea: { title: 'New Test title' } }
        idea.reload
        expect(idea.title).to eq 'New Test title'
      end

      it 'should not be able to update another users idea' do
        patch idea_path(idea_by_admin), params: { idea: { title: 'New Test title' } }
        idea_by_admin.reload
        expect(idea.title).to eq 'New idea1'
      end

      it 'should not be able to update an idea once submitted' do
        patch idea_path(submitted_idea), params: { idea: { title: 'New Test title' } }
        submitted_idea.reload
        expect(idea.title).to eq 'New idea1'
      end
    end

    describe 'delete an idea' do
      it 'should delete an existing idea' do
        delete idea_path(idea)
        expect(Idea.exists?(idea.id)).to eq false
      end
    end

    describe 'submitting an idea with all data' do
      it 'should set the submission date on an idea and all fields present' do
        post idea_submit_path(complete_idea)
        complete_idea.reload
        expect(complete_idea.submission_date).to_not be_nil
        expect(complete_idea.status).to eq 'awaiting_approval'
        expect(complete_idea.area_of_interest).to_not be_nil
        expect(complete_idea.title).to_not be_nil
        expect(complete_idea.idea).to_not be_nil
        expect(complete_idea.benefits).to_not be_nil
        expect(complete_idea.impact).to_not be_nil
        expect(complete_idea.involvement).to_not be_nil
      end
    end

    describe 'submitting an idea with missing data' do
      it 'should not set the submission date on an idea where fields are missing' do
        post idea_submit_path(idea)
        expect(idea.submission_date).to be_nil
        expect(response.body).to include('prohibited this idea from being saved:')
      end
    end

    describe 'submitting an idea with an it sytem and invalid area of interest' do
      it 'should not update existing idea' do
        patch idea_path(idea), params: { idea: { it_system: 'cwa',
                                                 area_of_interest: 'my_office' } }
        post idea_submit_path(idea)
        expect(it_idea.it_system).to be_nil
        expect(response.body).to include('IT System invalid area of interest')
      end
    end

    describe 'submitting an idea with a business area and invalid area of interest' do
      it 'should not update existing idea' do
        patch idea_path(idea), params: { idea: { business_area: 'exceptional_and_complex_cases',
                                                 area_of_interest: 'equality_and_diversity' } }
        post idea_submit_path(idea)
        expect(submitted_idea.business_area).to be_nil
        expect(response.body).to include('Business Area invalid area of interest')
      end
    end
  end

  describe "As user who isn't logged in" do
    describe 'GET /ideas' do
      it 'redirects to the login page' do
        get ideas_path
        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe 'As an admin user who is logged in' do
    before do
      sign_in admin_user
    end

    describe 'GET /ideas' do
      it 'should show a list of ideas' do
        idea
        idea2
        get ideas_path
        expect(response).to have_http_status(200)
        expect(response.body).to include 'New idea1'
        expect(response.body).to include 'New idea2'
      end

      it 'should show a users button' do
        get ideas_path
        expect(response.body).to include '<a href="/users">Users</a>'
      end
    end

    describe 'PATCH /idea' do
      it 'should show admin only fields' do
        get edit_idea_path(idea)
        expect(response.body).to include 'assigned_user_id'
        expect(response.body).to include 'status'
        expect(response.body).to include 'Involvement'
        expect(response.body).to include 'review_date'
      end
    end

    describe 'update admin fields' do
      it 'should update existing idea' do
        patch idea_path(idea), params: { idea: { assigned_user_id: admin_user.id, status: 'approved',
                                                 participation_level: 'assist', review_year: Date.today.year,
                                                 review_month: Date.today.month, review_day: Date.today.day } }
        idea.reload
        expect(idea.assigned_user_id).to eq admin_user.id
        expect(idea.status).to eq 'approved'
        expect(idea.participation_level).to eq 'assist'
        expect(idea.review_date).to eq Date.today
      end
    end

    describe 'update an idea' do
      it 'should change another users idea' do
        patch idea_path(idea), params: { idea: { title: 'New Test title' } }
        idea.reload
        expect(idea.title).to eq 'New Test title'
      end

      it 'edit a submitted idea' do
        patch idea_path(submitted_idea), params: { idea: { title: 'New Test title' } }
        submitted_idea.reload
        expect(submitted_idea.title).to eq 'New Test title'
      end
    end

    describe 'submitting an idea with a past review date' do
      it 'should not update existing idea' do
        patch idea_path(idea), params: { idea: { assigned_user_id: admin_user.id, status: 'approved',
                                                 participation_level: 'assist', review_year: Date.yesterday.year,
                                                 review_month: Date.yesterday.month, review_day: Date.yesterday.day } }
        expect(idea.review_date).to be_nil
        expect(response.body).to include('Review date cannot be in the past')
      end
    end

    describe 'submitting an idea with an invalid date' do
      it 'should not update existing idea' do
        patch idea_path(idea), params: { idea: { assigned_user_id: admin_user.id, status: 'approved',
                                                 participation_level: 'assist', review_year: Date.today.year,
                                                 reciew_month: '13', review_day: Date.today.day } }
        expect(idea.review_date).to be_nil
      end
    end
  end
end

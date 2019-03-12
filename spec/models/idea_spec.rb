# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Idea, type: :model do
  describe 'relations' do
    it { should belong_to(:user) }
    it { should have_many(:votes) }
  end

  describe 'validations' do
    context 'if submitted' do
      before { allow(subject).to receive(:submitted?).and_return(true) }
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:area_of_interest) }
      it { should validate_presence_of(:business_area) }
      it { should validate_presence_of(:it_system) }
      it { should validate_presence_of(:benefits) }
      it { should validate_presence_of(:impact) }
      it { should validate_presence_of(:involvement) }
    end

    context 'if not submitted it' do
      before { allow(subject).to receive(:submitted?).and_return(false) }
      it { should validate_presence_of(:title) }
      it { should_not validate_presence_of(:area_of_interest) }
      it { should_not validate_presence_of(:business_area) }
      it { should_not validate_presence_of(:it_system) }
      it { should_not validate_presence_of(:impact) }
      it { should_not validate_presence_of(:involvement) }
    end
  end

  describe 'fields which should be enums' do
    it { should define_enum_for(:involvement) }
    it { should define_enum_for(:it_system) }
    it { should define_enum_for(:business_area) }
    it { should define_enum_for(:area_of_interest) }
  end

  describe 'benefit_list=' do
    %i[saved unsaved].each do |saved_state|
      describe "on a #{saved_state} record" do
        before do
          @user = create :user
          if saved_state == :saved
            @idea = @user.ideas.create!(title: 'Test idea')
            expect(@idea.new_record?).to be false
          else
            @idea = @user.ideas.new(title: 'Test idea')
            expect(@idea.new_record?).to be true
          end
        end
        it 'should add relations when passing in a list of benefits' do
          expect(@idea.benefits).to be_empty
          @idea.benefit_list = %i[cost time_saved]
          expect(@idea.benefits.map(&:benefit).sort).to eq %w[cost time_saved]
        end
        it 'should remove relations when a benefit has been removed' do
          @idea.benefit_list = %i[cost time_saved]
          expect(@idea.benefits.map(&:benefit).sort).to eq %w[cost time_saved]
          @idea.benefit_list = [:cost]
          expect(@idea.benefits.map(&:benefit).sort).to eq ['cost']
        end
      end
    end
  end

  describe 'benefit?' do
    let(:complete_idea) { create :complete_idea }
    it 'should return true if an idea has the passed in benefit' do
      expect(complete_idea.benefit?(:cost)).to eq true
    end
    it 'should return false if an idea does not have the benefit' do
      expect(complete_idea.benefit?(:time_saved)).to eq false
    end
  end

  context 'user defined scopes' do
    let(:user_1) { create :user }
    let(:user_2) { create :user, email: 'user2@justice.gov.uk'}
    describe 'allocated ideas' do
      it 'returns ideas which are allocated to a certain user' do
        idea1 = create :idea, assigned_user_id: user_1.id
        idea2 = create :idea, assigned_user_id: user_1.id
        idea3 = create :idea, assigned_user_id: user_2.id
        expect(Idea.allocated_ideas(user_1)).to match_array [idea1,idea2]
      end
    end

    describe 'my ideas' do
      it 'returns ideas which are created by a certain user' do
        idea1 = create :idea, user: user_1
        idea2 = create :idea, user: user_1
        idea3 = create :idea, user: user_2
        expect(Idea.my_ideas(user_1)).to match_array [idea1, idea2]
      end
    end

    describe 'approved or beyond' do
      it 'returns all ideas which dont contain awaiting_approval or draft status' do
        idea1 = create :idea, :draft, user: user_1
        idea2 = create :idea, :awaiting_approval, user: user_2
        idea3 = create :idea, :approved, user: user_1
        idea4 = create :idea, :investigation, user: user_2
        idea5 = create :idea, :implementing, user: user_1
        idea6 = create :idea, :interim_benefits, user: user_2
        idea7 = create :idea, :benefits_realised, user: user_1
        idea8 = create :idea, :not_proceeding, user: user_2
        expect(Idea.approved_or_beyond).to match_array [idea3, idea4, idea5, idea6, idea7, idea8]
      end
    end

    describe 'default scope' do
      it 'should order the ideas by submitted date ascending' do
        idea1 = create :submitted_idea, user: user_1
        idea1.update!(submission_date: 6.days.ago)
        idea2 = create :submitted_idea, user: user_1
        idea2.update!(submission_date: 8.days.ago)
        idea3 = create :submitted_idea, user: user_1
        idea3.update!(submission_date: 2.days.ago)
        idea4 = create :idea, :draft, user: user_1
        expect(Idea.all).to eq [idea2, idea1, idea3, idea4]
      end
    end

    describe 'overide default scope' do
      it 'should order the ideas by submitted date descending' do
        idea1 = create :submitted_idea, user: user_1
        idea1.update!(submission_date: 6.days.ago)
        idea2 = create :submitted_idea, user: user_1
        idea2.update!(submission_date: 8.days.ago)
        idea3 = create :submitted_idea, user: user_1
        idea3.update!(submission_date: 2.days.ago)
        idea4 = create :idea, :draft, user: user_1
        expect(Idea.unscoped.order(submission_date: :desc)).to eq [idea4, idea3, idea1, idea2]
      end
    end

    describe 'review' do
      it 'returns all ideas (ordered by review date asc) which are approved, investigation, implementing, interim_benefits' do
        idea1 = create :idea, :draft, user: user_1
        idea2 = create :idea, :awaiting_approval, user: user_2
        idea3 = create :idea, :approved, user: user_1, review_date: 5.days.ago
        idea4 = create :idea, :investigation, user: user_2, review_date: 2.days.ago
        idea5 = create :idea, :implementing, user: user_1, review_date: 7.days.ago
        idea6 = create :idea, :interim_benefits, user: user_2, review_date: 3.days.ago
        idea7 = create :idea, :benefits_realised, user: user_1, review_date: 8.days.ago
        idea8 = create :idea, :not_proceeding, user: user_2, review_date: 9.days.ago
        expect(Idea.review.pluck(:id, :review_date)).to eq [idea5, idea3, idea6, idea4].pluck(:id, :review_date)
      end
    end
  end
end

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
end

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
      it { should_not validate_presence_of(:benefits) }
      it { should_not validate_presence_of(:impact) }
      it { should_not validate_presence_of(:involvement) }
    end
  end

  describe 'fields which should be enums' do
    it { should define_enum_for(:benefits) }
    it { should define_enum_for(:involvement) }
    it { should define_enum_for(:it_system) }
    it { should define_enum_for(:business_area) }
    it { should define_enum_for(:area_of_interest) }
  end
end

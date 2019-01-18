# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:idea) }
  end

  describe 'validations' do
    subject { build :vote }
    it { should validate_uniqueness_of(:idea_id).scoped_to(:user_id).with_message('Only one vote per user per idea') }
  end
end

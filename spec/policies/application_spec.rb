# frozen_string_literal: true

describe ApplicationPolicy do
  subject { described_class }

  let(:default_user) { build :user }
  let(:idea) { build :idea }

  permissions :index?, :show?, :new?, :create?, :destroy?, :update?, :edit? do
    it 'denies access as default' do
      expect(subject).not_to permit(default_user, idea)
    end
  end
end

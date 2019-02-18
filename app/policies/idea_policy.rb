# frozen_string_literal: true

class IdeaPolicy < ApplicationPolicy
  def update?
    return true if user.admin

    owner? && !record.submitted?
  end

  private

  def owner?
    record.user == user
  end
end

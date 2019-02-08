# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def update?
    return record.approved_by_admin? if user.admin
    return record.approved_by_admin? && !record.not_proceeding? unless user.admin
  end

  def create?
    update?
  end
end

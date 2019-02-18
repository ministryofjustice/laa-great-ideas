# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def new?
    create?
  end

  def update?
    return true if user.admin

    record.user == user
  end

  def create?
    if user.admin
      admin_commentable_record?
    else
      user_commentable_record?
    end
  end

  private

  def user_commentable_record?
    record.approved_by_admin? && record.proceeding?
  end

  def admin_commentable_record?
    record.approved_by_admin?
  end
end

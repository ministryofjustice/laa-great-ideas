# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def new?
    create?
  end

  def update?
    return true if user.admin

    owner? && record.redacted? == false
  end

  def create?
    if user.admin
      admin_commentable_record?
    else
      user_commentable_record?
    end
  end

  def destroy?
    return true if user.admin && record.redacted? == false

    owner? && !record.redacted?
  end

  private

  def user_commentable_record?
    record.approved_by_admin? && record.proceeding?
  end

  def admin_commentable_record?
    record.approved_by_admin?
  end

  def owner?
    record.user == user
  end
end

# frozen_string_literal: true

module CommentsHelper
  def user_can_comment?(idea, user)
    return idea.approved_by_admin? if user.admin
    return idea.approved_by_admin? && !idea.not_proceeding? unless user.admin
  end
end

# frozen_string_literal: true

class Comment < ApplicationRecord
  enum status_at_comment_time: Idea.statuses

  belongs_to :user
  belongs_to :idea

  validates :body, presence: true
end

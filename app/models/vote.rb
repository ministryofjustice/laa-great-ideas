# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :idea

  validates :idea_id, uniqueness: { scope: :user_id,
                                    message: 'Only one vote per user per idea' }
end

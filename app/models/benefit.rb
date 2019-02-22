# frozen_string_literal: true

class Benefit < ApplicationRecord
  belongs_to :idea

  enum benefit: %i[
    better_decision_making
    improved_reputation
    reduced_risk
    time_saved
    cost
    improved_service
    staff_engagement_and_morale
  ]
end

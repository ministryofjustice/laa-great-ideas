# frozen_string_literal: true

module Votable
  include ActiveSupport::Concern

  def user_voted?(user)
    votes.exists?(user: user)
  end
end

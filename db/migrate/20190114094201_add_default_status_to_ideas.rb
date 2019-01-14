# frozen_string_literal: true

class AddDefaultStatusToIdeas < ActiveRecord::Migration[5.2]
  def change
    change_column_default :ideas, :status, Idea.statuses[:draft]
  end
end

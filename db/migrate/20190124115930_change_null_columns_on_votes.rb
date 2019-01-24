# frozen_string_literal: true

class ChangeNullColumnsOnVotes < ActiveRecord::Migration[5.2]
  def change
    change_column_null :votes, :idea_id, false
  end
end

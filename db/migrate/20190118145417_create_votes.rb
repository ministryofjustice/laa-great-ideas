# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.timestamps
      t.references :idea, foreign_key: true
      t.references :user, foreign_key: true
      t.index %i[idea_id user_id], unique: true
    end
  end
end

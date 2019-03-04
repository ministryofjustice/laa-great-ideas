# frozen_string_literal: true

class CreateBenefits < ActiveRecord::Migration[5.2]
  def change
    create_table :benefits do |t|
      t.timestamps
      t.references :idea, foreign_key: true
      t.integer :benefit, foreign_key: true
      t.index %i[idea_id benefit], unique: true
      t.timestamps
    end

    remove_column(:ideas, :benefits)
  end
end

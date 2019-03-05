# frozen_string_literal: true

class AddRedactedToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :redacted, :boolean, default: false
  end
end

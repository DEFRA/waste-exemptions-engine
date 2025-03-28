# frozen_string_literal: true

class AddObjectChangesToVersions < ActiveRecord::Migration[7.2]
  def change
    add_column :versions, :object_changes, :jsonb
  end
end

# frozen_string_literal: true

class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table(:registrations) do |t|
      t.string :workflow_state
      t.timestamps null: false
    end
  end
end

# frozen_string_literal: true

class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table(:enrollments) do |t|
      t.string :workflow_state
      t.timestamps null: false
    end
  end
end

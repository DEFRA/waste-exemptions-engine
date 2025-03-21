# frozen_string_literal: true

class AddReasonForChangeToRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :reason_for_change, :string, limit: 500
  end
end

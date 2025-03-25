# frozen_string_literal: true

class AddReasonForChangeToTransientRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :transient_registrations, :reason_for_change, :string, limit: 500
  end
end

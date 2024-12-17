# frozen_string_literal: true

class AddTempExemptionsToTransientRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :transient_registrations, :temp_exemptions, :text, array: true, default: []
  end
end

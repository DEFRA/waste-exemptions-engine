# frozen_string_literal: true

class AddTempConfirmExemptionsToTransientRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :transient_registrations, :temp_confirm_exemptions, :boolean, default: nil
  end
end

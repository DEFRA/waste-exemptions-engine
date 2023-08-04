# frozen_string_literal: true

class AddTempConfirmExemptionEditsToTransientRegistration < ActiveRecord::Migration[7.0]
  def up
    add_column :transient_registrations, :temp_confirm_exemption_edits, :boolean, default: nil
    add_column :transient_registrations, :temp_confirm_no_exemption_changes, :boolean, default: nil
  end

  def down
    remove_column :transient_registrations, :temp_confirm_exemption_edits
    remove_column :transient_registrations, :temp_confirm_no_exemption_changes
  end
end

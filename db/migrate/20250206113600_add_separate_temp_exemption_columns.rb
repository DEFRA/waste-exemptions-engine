# frozen_string_literal: true

class AddSeparateTempExemptionColumns < ActiveRecord::Migration[7.1]
  def change
    add_column :transient_registrations, :temp_farm_exemptions, :text, array: true, default: []
    add_column :transient_registrations, :temp_activity_exemptions, :text, array: true, default: []
  end
end

# frozen_string_literal: true

class AddSeparateTempExemptionColumns < ActiveRecord::Migration[7.1]
  def change
    add_column :transient_registrations, :temp_add_additional_non_farm_exemptions, :boolean
  end
end

# frozen_string_literal: true

class AddExcludedExemptionsToTransientRegistration < ActiveRecord::Migration[6.1]
  def change
    add_column :transient_registrations, :excluded_exemptions, :text, array: true, default: []
  end
end

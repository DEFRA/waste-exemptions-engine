# frozen_string_literal: true

class AddLegacyBulkLinearToRegistration < ActiveRecord::Migration[7.2]
  def change
    add_column :transient_registrations, :is_legacy_bulk, :boolean, default: false
    add_column :registrations, :is_legacy_bulk, :boolean, default: false

    add_column :transient_registrations, :is_legacy_linear, :boolean, default: false
    add_column :registrations, :is_legacy_linear, :boolean, default: false
  end
end

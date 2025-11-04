# frozen_string_literal: true

class RenameIsLegacyLinearToIsLinear < ActiveRecord::Migration[7.2]
  def change
    rename_column :registrations, :is_legacy_linear, :is_linear
    rename_column :transient_registrations, :is_legacy_linear, :is_linear
  end
end

# frozen_string_literal: true

class RenameIsAFarmToOnAFarm < ActiveRecord::Migration[4.2]
  def change
    rename_column :registrations, :is_a_farm, :on_a_farm
    rename_column :transient_registrations, :is_a_farm, :on_a_farm
  end
end

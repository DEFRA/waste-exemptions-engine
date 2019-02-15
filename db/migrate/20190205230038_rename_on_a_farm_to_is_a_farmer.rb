# frozen_string_literal: true

class RenameOnAFarmToIsAFarmer < ActiveRecord::Migration
  def change
    rename_column :registrations, :on_a_farm, :is_a_farmer
    rename_column :transient_registrations, :on_a_farm, :is_a_farmer
  end
end

# frozen_string_literal: true

class AddOnAFarmToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :on_a_farm, :boolean
  end
end

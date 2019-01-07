# frozen_string_literal: true

class AddIsAFarmToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :is_a_farm, :boolean
  end
end

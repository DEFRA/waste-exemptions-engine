# frozen_string_literal: true

class AddLocationToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :location, :string
  end
end

# frozen_string_literal: true

class AddStartOptionToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :start_option, :string
  end
end

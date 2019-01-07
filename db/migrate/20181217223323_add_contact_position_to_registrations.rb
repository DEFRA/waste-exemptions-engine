# frozen_string_literal: true

class AddContactPositionToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :contact_position, :string
  end
end

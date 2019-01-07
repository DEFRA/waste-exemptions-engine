# frozen_string_literal: true

class AddReferenceToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :reference, :string
  end
end

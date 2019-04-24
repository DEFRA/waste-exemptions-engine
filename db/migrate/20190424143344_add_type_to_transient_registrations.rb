# frozen_string_literal: true

class AddTypeToTransientRegistrations < ActiveRecord::Migration
  def change
    add_column :transient_registrations, :type, :string
  end
end

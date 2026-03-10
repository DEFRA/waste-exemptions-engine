# frozen_string_literal: true

class AddCharitablePurposeToTransientRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :transient_registrations, :charitable_purpose, :boolean
    add_column :transient_registrations, :charitable_purpose_declaration, :boolean
  end
end

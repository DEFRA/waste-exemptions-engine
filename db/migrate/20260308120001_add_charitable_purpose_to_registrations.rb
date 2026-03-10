# frozen_string_literal: true

class AddCharitablePurposeToRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :charitable_purpose, :boolean
  end
end

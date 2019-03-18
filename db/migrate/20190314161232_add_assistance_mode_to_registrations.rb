# frozen_string_literal: true

class AddAssistanceModeToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :assistance_mode, :string
  end
end

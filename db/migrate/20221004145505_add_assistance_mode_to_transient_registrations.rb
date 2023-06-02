# frozen_string_literal: true

class AddAssistanceModeToTransientRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :transient_registrations, :assistance_mode, :string, default: nil
  end
end

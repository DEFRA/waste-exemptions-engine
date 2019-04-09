# frozen_string_literal: true

class AddAssistanceModeAndSubmittedAtToTransientRegistrations < ActiveRecord::Migration
  def change
    add_column :transient_registrations, :assistance_mode, :string
    add_column :transient_registrations, :submitted_at, :date
  end
end

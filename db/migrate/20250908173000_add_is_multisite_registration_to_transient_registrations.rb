# frozen_string_literal: true

class AddIsMultisiteRegistrationToTransientRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :transient_registrations, :is_multisite_registration, :boolean
  end
end

# frozen_string_literal: true

class AddIsMultisiteRegistrationToTransientRegistrations < ActiveRecord::Migration[7.2]
  def change
    add_column :transient_registrations, :is_multisite_registration, :boolean
  end
end

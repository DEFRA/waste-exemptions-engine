# frozen_string_literal: true

class AddIsMultisiteRegistrationToRegistrations < ActiveRecord::Migration[7.2]
  def change
    add_column :registrations, :is_multisite_registration, :boolean
  end
end

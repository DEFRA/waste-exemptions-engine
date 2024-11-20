# frozen_string_literal: true

class AddTempWasteActivitiesToTransientRegistration < ActiveRecord::Migration[7.1]
  def change
    add_column :transient_registrations, :temp_waste_activities, :text, array: true, default: []
  end
end

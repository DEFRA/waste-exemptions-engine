# frozen_string_literal: true

class AddSubmittedAtToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :submitted_at, :date

    WasteExemptionsEngine::Registration.all.each do |registration|
      registration.update_attributes(submitted_at: registration.created_at)
    end
  end
end

# frozen_string_literal: true

class AddSubmittedAtToRegistrations < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :submitted_at, :date

    WasteExemptionsEngine::Registration.all.each do |registration|
      registration.update(submitted_at: registration.created_at)
    end
  end
end

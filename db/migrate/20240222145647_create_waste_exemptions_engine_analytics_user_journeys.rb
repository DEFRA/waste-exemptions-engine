# frozen_string_literal: true

class CreateWasteExemptionsEngineAnalyticsUserJourneys < ActiveRecord::Migration[7.0]
  def change
    create_table :analytics_user_journeys do |t|
      t.string :journey_type
      t.datetime :completed_at
      t.string :token
      t.string :user
      t.string :started_route
      t.string :completed_route
      t.text :registration_data

      t.timestamps
    end
  end
end

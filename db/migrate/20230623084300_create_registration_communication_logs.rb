# frozen_string_literal: true

class CreateRegistrationCommunicationLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :registration_communication_logs do |t|
      t.belongs_to :registration, index: true
      t.belongs_to :communication_log, index: true

      t.timestamps null: false
    end
  end
end

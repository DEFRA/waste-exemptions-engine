# frozen_string_literal: true

class CreateRegistrationExemptions < ActiveRecord::Migration[4.2]
  def change
    create_table :registration_exemptions do |t|
      t.string :state
      t.date :registered_on
      t.date :expires_on
      t.belongs_to :registration, index: true
      t.belongs_to :exemption, index: true

      t.timestamps null: false
    end
  end
end

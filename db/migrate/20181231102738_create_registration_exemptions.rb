# frozen_string_literal: true

class CreateRegistrationExemptions < ActiveRecord::Migration
  def change
    create_table :registration_exemptions do |t|
      t.belongs_to :registration, index: true
      t.belongs_to :exemption, index: true

      t.timestamps null: false
    end
  end
end

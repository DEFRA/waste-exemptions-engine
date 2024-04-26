# frozen_string_literal: true

class CreateWasteExemptionsEngineBands < ActiveRecord::Migration[7.1]
  def change
    create_table :bands do |t|
      t.string :name
      t.integer :sequence
      t.integer :registration_fee
      t.integer :initial_compliance_charge
      t.integer :additional_compliance_charge

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreateWasteExemptionsEngineChargeDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :charge_details do |t|
      t.integer :registration_charge_amount
      t.integer :bucket_charge_amount, default: 0

      t.timestamps
    end
  end
end

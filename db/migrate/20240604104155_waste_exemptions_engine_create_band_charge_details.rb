# frozen_string_literal: true

class WasteExemptionsEngineCreateBandChargeDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :band_charge_details do |t|
      t.bigint "band_id"

      t.integer :initial_compliance_charge_amount, default: 0
      t.integer :additional_compliance_charge_amount, default: 0

      t.timestamps
    end
  end
end

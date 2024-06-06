# frozen_string_literal: true

class WasteExemptionsEngineCreateChargeDetailBandChargeDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :charge_detail_band_charge_details do |t|
      t.references :charge_detail, foreign_key: true
      t.references :band_charge_detail, foreign_key: true

      t.timestamps
    end
  end
end

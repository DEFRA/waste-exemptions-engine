# frozen_string_literal: true

class CreateWasteExemptionsEngineCharges < ActiveRecord::Migration[7.1]
  def change
    create_table :charges do |t|
      t.string :name, null: false
      t.string :charge_type, null: false, index: true
      t.integer :charge_amount, null: false

      t.references :chargeable, polymorphic: true
      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreateWasteExemptionsEngineOrderExemptions < ActiveRecord::Migration[7.1]
  def change
    create_table :order_exemptions do |t|
      t.references :order, foreign_key: true
      t.references :exemption, foreign_key: true

      t.timestamps
    end
  end
end

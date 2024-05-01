# frozen_string_literal: true

class CreateWasteExemptionsEngineBuckets < ActiveRecord::Migration[7.1]
  def change
    create_table :buckets do |t|
      t.string :name
      t.integer :charge_amount

      t.timestamps
    end
  end
end

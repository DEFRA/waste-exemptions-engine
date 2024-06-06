# frozen_string_literal: true

class CreateWasteExemptionsEngineOrderBuckets < ActiveRecord::Migration[7.1]
  def change
    create_table :order_buckets do |t|
      t.references :order, foreign_key: true
      t.references :bucket, foreign_key: true

      t.timestamps
    end
  end
end

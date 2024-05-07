# frozen_string_literal: true

class CreateWasteExemptionsEngineBuckets < ActiveRecord::Migration[7.1]
  def change
    create_table :buckets do |t|
      t.string :name

      t.timestamps
    end
  end
end

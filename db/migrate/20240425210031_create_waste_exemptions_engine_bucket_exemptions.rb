# frozen_string_literal: true

class CreateWasteExemptionsEngineBucketExemptions < ActiveRecord::Migration[7.1]
  def change
    create_table :bucket_exemptions do |t|
      t.references :bucket, foreign_key: true
      t.references :exemption, foreign_key: true

      t.timestamps
    end
  end
end

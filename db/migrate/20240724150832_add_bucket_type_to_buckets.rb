# frozen_string_literal: true

class AddBucketTypeToBuckets < ActiveRecord::Migration[7.1]
  def change
    add_column :buckets, :bucket_type, :string
    add_index :buckets, :bucket_type, unique: true
  end
end

# frozen_string_literal: true

class AddUniqueIndexToBucketsName < ActiveRecord::Migration[7.1]
  def change
    add_index :buckets, :name, unique: true
  end
end
